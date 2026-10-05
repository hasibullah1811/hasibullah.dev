import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../widgets/common.dart';
import 'journey_cards.dart';
import 'journey_painters.dart';

/// The journey as a route from Bangladesh to Australia.
///
/// Layers, bottom to top, each behind its own RepaintBoundary:
///  1. drifting contour lines (paused when off screen),
///  2. the route, drawn up to the scroll position by [RoutePainter],
///  3. the cards, which reveal once as the route reaches them.
///
/// Rows are laid out normally, then measured after layout so the painter
/// knows where each node sits. Scrolling only updates [_drawY], which
/// repaints the route; widgets are not rebuilt.
class JourneySection extends StatefulWidget {
  const JourneySection({super.key, required this.journey});

  final Journey journey;

  @override
  State<JourneySection> createState() => _JourneySectionState();
}

enum _Kind { origin, chapter, stop, spanNote, move, destination }

class _Row {
  _Row(this.kind, {this.chapter, this.stop, this.span});

  final _Kind kind;
  final JourneyChapter? chapter;
  final JourneyStop? stop;
  final JourneySpan? span;
  final key = GlobalKey();

  /// Offset of the node from the row's top, aligned with its first line.
  double get nodeOffset => kind == _Kind.chapter ? 15 : 26;
  bool get hasNode => kind == _Kind.chapter || kind == _Kind.stop;
}

class _JourneySectionState extends State<JourneySection>
    with TickerProviderStateMixin {
  final _stackKey = GlobalKey();
  final _geometry = ValueNotifier<JourneyGeometry?>(null);
  final _drawY = _DrawPosition();
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );

  ScrollPosition? _position;
  List<_Row> _rows = const [];
  bool _compact = false;
  bool _reduced = false;
  double _viewportHeight = 0;

  // Lane widths (left of the cards).
  double get _spineLane => _compact ? 24 : 28;
  double get _sideLane => _compact ? 0 : 30;
  double get _contentX => _spineLane + _sideLane + 12;
  double get _bulge => _compact ? 26 : 46;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.disableAnimationsOf(context);
    _viewportHeight = MediaQuery.sizeOf(context).height;
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_onScroll);
      _position = position?..addListener(_onScroll);
    }
    if (_reduced) _drift.stop();
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    _drift.dispose();
    _geometry.dispose();
    _drawY.dispose();
    super.dispose();
  }

  void _onScroll() => _updateDrawY();

  RenderBox? get _stackBox {
    final box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    return box != null && box.attached && box.hasSize ? box : null;
  }

  void _updateDrawY() {
    final box = _stackBox;
    if (box == null) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final height = box.size.height;
    final visible = top < _viewportHeight && top + height > 0;

    if (!_reduced && visible && !_drift.isAnimating) {
      _drift.repeat();
    } else if ((!visible || _reduced) && _drift.isAnimating) {
      _drift.stop();
    }

    _drawY.value = _reduced
        ? height
        : (_viewportHeight * 0.62 - top).clamp(0.0, height);
  }

  void _measure() {
    final box = _stackBox;
    if (box == null) return;
    double top(_Row row) {
      final rowBox = row.key.currentContext!.findRenderObject() as RenderBox;
      return rowBox.localToGlobal(Offset.zero, ancestor: box).dy;
    }

    double bottom(_Row row) =>
        top(row) + (row.key.currentContext!.size?.height ?? 0);

    final origin = _rows.first;
    final destination = _rows.last;
    final move = _rows.firstWhere((r) => r.kind == _Kind.move);

    JourneySpanGeometry? span;
    final note = _rows.where((r) => r.kind == _Kind.spanNote).firstOrNull;
    if (note != null) {
      final first = _rows.firstWhere(
        (r) => r.kind == _Kind.stop && r.stop!.year >= note.span!.startYear,
      );
      span = JourneySpanGeometry(
        x: _spineLane + 4,
        top: top(first) + first.nodeOffset,
        bottom: top(note) + 10,
        hookTo: _contentX - 6,
      );
    }

    final next = JourneyGeometry(
      spineX: _spineLane / 2,
      originY: bottom(origin) + 6,
      destinationY: top(destination) - 6,
      moveTop: top(move),
      moveBottom: bottom(move),
      bulge: _bulge,
      height: box.size.height,
      span: span,
      nodes: [
        for (final row in _rows)
          if (row.hasNode)
            JourneyNode(
              top(row) + row.nodeOffset,
              chapter: row.kind == _Kind.chapter,
            ),
      ],
    );
    if (!next.sameLayout(_geometry.value)) _geometry.value = next;
    _updateDrawY();
    // Cards check their reveal point on every notification, including when
    // the layout moved but the scroll position did not.
    _drawY.poke();
  }

  List<_Row> _buildRows(Journey journey) {
    final rows = <_Row>[_Row(_Kind.origin)];
    for (var c = 0; c < journey.chapters.length; c++) {
      final chapter = journey.chapters[c];
      if (c > 0) rows.add(_Row(_Kind.move));
      rows.add(_Row(_Kind.chapter, chapter: chapter));

      final span = chapter.span;
      final stops = [
        if (span != null && _compact) span.asStop(),
        ...chapter.stops,
      ];
      // Chronological; ties keep their order in the data file.
      final ordered = [for (var i = 0; i < stops.length; i++) (i, stops[i])]
        ..sort((a, b) {
          final byYear = a.$2.year.compareTo(b.$2.year);
          return byYear != 0 ? byYear : a.$1.compareTo(b.$1);
        });
      rows.addAll([for (final (_, s) in ordered) _Row(_Kind.stop, stop: s)]);
      if (span != null && !_compact) {
        rows.add(_Row(_Kind.spanNote, span: span));
      }
    }
    rows.add(_Row(_Kind.destination));
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final journey = widget.journey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(eyebrow: 'Journey', title: journey.title),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 560;
            if (compact != _compact || _rows.isEmpty) {
              _compact = compact;
              _rows = _buildRows(journey);
            }
            WidgetsBinding.instance.addPostFrameCallback((_) => _measure());

            return NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (_) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
                return false;
              },
              child: SizeChangedLayoutNotifier(
                child: Stack(
                  key: _stackKey,
                  children: [
                    Positioned.fill(
                      child: ExcludeSemantics(
                        child: RepaintBoundary(
                          child: CustomPaint(painter: ContourPainter(_drift)),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: ExcludeSemantics(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: RoutePainter(
                              geometry: _geometry,
                              drawY: _drawY,
                              reduced: _reduced,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_compact) _spanLabel(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [for (final row in _rows) _buildRow(row)],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Text written along the part-time bar, positioned once measured.
  Widget _spanLabel() {
    final label = widget.journey.chapters
        .map((c) => c.span?.label)
        .nonNulls
        .firstOrNull;
    if (label == null) return const SizedBox.shrink();
    return ValueListenableBuilder(
      valueListenable: _geometry,
      builder: (context, g, _) {
        final span = g?.span;
        if (span == null) return const SizedBox.shrink();
        final length = span.bottom - span.top - 40;
        if (length < 60) return const SizedBox.shrink();
        return Positioned(
          left: _spineLane + 10,
          top: span.top + 8,
          width: 16,
          height: length,
          child: RotatedBox(
            quarterTurns: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label.toUpperCase(),
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(_Row row) {
    final journey = widget.journey;
    final content = switch (row.kind) {
      _Kind.origin || _Kind.destination => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          (row.kind == _Kind.origin ? journey.origin : journey.destination)
              .toUpperCase(),
          style: AppText.eyebrow,
        ),
      ),
      _Kind.chapter => _withLane(
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 18),
          child: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Semantics(
                header: true,
                headingLevel: 3,
                child: Text(row.chapter!.name, style: AppText.cardTitle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(row.chapter!.period, style: AppText.label),
              ),
            ],
          ),
        ),
      ),
      _Kind.stop => _withLane(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _reveal(
            row,
            (reveal) => LiftCard(
              child: StopContent(stop: row.stop!, reveal: reveal),
            ),
          ),
        ),
      ),
      _Kind.spanNote => _withLane(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _reveal(row, (_) => _SpanNote(row.span!)),
        ),
      ),
      _Kind.move => _withLane(
        Padding(
          padding: EdgeInsets.only(
            left: _bulge - 4,
            top: _compact ? 28 : 40,
            bottom: _compact ? 28 : 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                journey.chapters.map((c) => c.name).join('  →  ').toUpperCase(),
                style: AppText.label,
              ),
              const SizedBox(height: 4),
              Text(
                journey.move,
                style: AppText.cardTitle.copyWith(
                  fontSize: 20,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    };
    return KeyedSubtree(key: row.key, child: content);
  }

  Widget _withLane(Widget child) => Padding(
    padding: EdgeInsets.only(left: _contentX),
    child: child,
  );

  Widget _reveal(_Row row, Widget Function(Animation<double>) build) {
    return RevealOnce(
      drawY: _drawY,
      reduced: _reduced,
      revealAt: () {
        final g = _geometry.value;
        if (g == null) return null;
        final box = _stackBox;
        final rowBox = row.key.currentContext?.findRenderObject() as RenderBox?;
        if (box == null || rowBox == null || !rowBox.attached) return null;
        return rowBox.localToGlobal(Offset.zero, ancestor: box).dy +
            row.nodeOffset -
            4;
      },
      builder: (context, reveal) => RepaintBoundary(child: build(reveal)),
    );
  }
}

/// How far down the section the route is drawn, in section coordinates.
class _DrawPosition extends ValueNotifier<double> {
  _DrawPosition() : super(0);

  void poke() => notifyListeners();
}

class _SpanNote extends StatelessWidget {
  const _SpanNote(this.span);

  final JourneySpan span;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 2, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: span.period,
                  style: AppText.label.copyWith(color: AppColors.accent),
                ),
                const TextSpan(text: '  ·  alongside everything above'),
              ],
            ),
            style: AppText.label,
          ),
          const SizedBox(height: 6),
          Text(span.title, style: AppText.title),
          Text(
            span.organisation,
            style: AppText.body.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          BulletList(span.bullets),
          if (span.stack.isNotEmpty) ...[
            const SizedBox(height: 4),
            TagList(span.stack),
          ],
        ],
      ),
    );
  }
}
