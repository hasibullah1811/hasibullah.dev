import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme.dart';
import '../motion.dart';
import '../theme_transition.dart';

/// The glyphs that drift up near the pointer. Edit freely; each entry is
/// drawn as one piece of text in Geist Mono.
const codeSymbols = [
  '{',
  '}',
  '<',
  '/>',
  '(',
  ')',
  '[',
  ']',
  ';',
  '=>',
  '#',
  '//',
  '&&',
  '::',
];

/// Everything behind the page, fixed to the viewport:
///
/// 1. A faint dot grid (ink at 7%), painted once into a cached layer. On
///    touch devices that layer drifts slowly (a transform, no repaint).
/// 2. Code symbols. With a mouse, a few appear near the pointer and fade
///    within 500ms; the ticker runs only while one is visible. On touch, and
///    with reduced motion, a sparse fixed scatter is painted into the grid
///    layer instead (drifting with it on touch, static and fainter with
///    reduced motion).
/// 3. In dark mode, a few stars in the side margins, clear of the text
///    column, twinkling very slowly at about 8 frames a second.
///
/// No layer takes pointer events or appears in the semantics tree. At their
/// strongest the symbols and dots are ink at 8% on paper, which every text
/// colour clears at 5.1:1 or better in both themes (see theme.dart).
/// Everything pauses while the tab is hidden.
class PageBackground extends StatefulWidget {
  const PageBackground({
    super.key,
    required this.textColumnWidth,
    required this.child,
  });

  /// Width of the centred text column; stars stay outside it.
  final double textColumnWidth;
  final Widget child;

  static const spacing = 24.0;
  static const radius = 1.0;
  static const dotAlpha = 0.07;

  /// Peak alpha of a pointer symbol. The same alpha reads weaker on the
  /// dark page, so dark gets a touch more.
  static double symbolAlpha(AppColors c) => c.isDark ? 0.08 : 0.07;

  /// Alpha of the fixed scatter on touch devices and with reduced motion.
  static const scatterAlpha = 0.06;
  static const reducedScatterAlpha = 0.04;

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );
  late final Ticker _ticker = createTicker(_tick);
  final _field = _SymbolField();
  final _sky = ValueNotifier<double>(0);
  final _random = math.Random();
  late final AppLifecycleListener _lifecycle;
  Timer? _twinkle;

  bool _reduced = false;
  bool _dark = false;
  Offset? _lastSpawn;
  Duration _lastSpawnAt = Duration.zero;
  final _clock = Stopwatch()..start();

  // Mobile browsers report a touch platform; a real mouse turns drift off.
  bool _touch =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  _GlyphAtlas? _atlas;
  int _fontGeneration = 0;

  static const _life = Duration(milliseconds: 500);
  static const _maxAlive = 4;
  static const _minTravel = 64.0;
  static const _minInterval = Duration(milliseconds: 110);

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _updateMotion());
    // Fonts load after the first frame on the web; re-rasterise the glyphs
    // once Geist Mono arrives.
    PaintingBinding.instance.systemFonts.addListener(_onFonts);
  }

  void _onFonts() {
    if (!mounted) return;
    setState(() => _fontGeneration++);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = Motion.reduced(context);
    _dark = AppColors.of(context).isDark;
    _updateMotion();
  }

  bool get _visible {
    final state = WidgetsBinding.instance.lifecycleState;
    return state != AppLifecycleState.hidden &&
        state != AppLifecycleState.paused;
  }

  void _updateMotion() {
    final visible = _visible;
    final drift = _touch && !_reduced && visible;
    if (drift && !_drift.isAnimating) {
      _drift.repeat();
    } else if (!drift && _drift.isAnimating) {
      _drift.stop();
    }

    if (!visible || _reduced) _clearSymbols();

    final twinkle = _dark && !_reduced && visible;
    if (twinkle && _twinkle == null) {
      _twinkle = Timer.periodic(const Duration(milliseconds: 125), (_) {
        _sky.value = _clock.elapsedMilliseconds / 1000;
      });
    } else if (!twinkle && _twinkle != null) {
      _twinkle!.cancel();
      _twinkle = null;
    }
  }

  void _clearSymbols() {
    if (_ticker.isActive) _ticker.stop();
    if (_field.symbols.isNotEmpty) {
      _field.symbols.clear();
      _field.changed();
    }
  }

  _GlyphAtlas _glyphs(AppColors colors, double pixelRatio) {
    final atlas = _atlas;
    if (atlas != null &&
        atlas.color == colors.ink &&
        atlas.pixelRatio == pixelRatio &&
        atlas.fontGeneration == _fontGeneration) {
      return atlas;
    }
    final next = _GlyphAtlas(
      color: colors.ink,
      pixelRatio: pixelRatio,
      fontGeneration: _fontGeneration,
    );
    _atlas = next;
    // The old image may still be referenced by this frame's painters.
    if (atlas != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => atlas.dispose());
    }
    return next;
  }

  void _onHover(PointerHoverEvent event) {
    if (_reduced) return;
    if (_touch) {
      setState(() => _touch = false);
      _updateMotion();
    }
    final now = _clock.elapsed;
    final p = event.localPosition;
    final last = _lastSpawn;
    if (last != null && (p - last).distance < _minTravel) return;
    if (now - _lastSpawnAt < _minInterval) return;
    if (_field.symbols.length >= _maxAlive) return;

    _lastSpawn = p;
    _lastSpawnAt = now;
    final angle = _random.nextDouble() * 2 * math.pi;
    final distance = 22 + _random.nextDouble() * 24;
    _field.symbols.add(
      _Symbol(
        glyph: _random.nextInt(codeSymbols.length),
        centre: p + Offset(math.cos(angle), math.sin(angle)) * distance,
        born: now,
      ),
    );
    _field.now = now;
    if (!_ticker.isActive) _ticker.start();
    _field.changed();
  }

  void _tick(Duration _) {
    final now = _clock.elapsed;
    _field.now = now;
    _field.symbols.removeWhere((s) => now - s.born >= _life);
    // One last repaint to clear the final symbol, then stop.
    if (_field.symbols.isEmpty) _ticker.stop();
    _field.changed();
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_onFonts);
    _lifecycle.dispose();
    _twinkle?.cancel();
    _ticker.dispose();
    _drift.dispose();
    _field.dispose();
    _sky.dispose();
    _atlas?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final scatter = _touch || _reduced;
    final atlas = _glyphs(colors, pixelRatio);
    final starsIn = ThemeTransitionScope.starsOf(context);

    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _drift,
                    builder: (context, child) {
                      // Rests one grid step up and left, and loops less than
                      // half a step around that, so the oversized layer
                      // never shows an edge.
                      final a = _drift.value * 2 * math.pi;
                      const step = PageBackground.spacing;
                      return Transform.translate(
                        offset: Offset(
                          step / 2 * math.sin(a) - step,
                          step / 4 * math.sin(2 * a) - step,
                        ),
                        child: child,
                      );
                    },
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, _) {
                          final size = MediaQuery.sizeOf(context);
                          return RepaintBoundary(
                            child: CustomPaint(
                              size: Size(
                                size.width + PageBackground.spacing * 2,
                                size.height + PageBackground.spacing * 2,
                              ),
                              painter: _GridPainter(
                                dot: colors.ink.withValues(
                                  alpha: PageBackground.dotAlpha,
                                ),
                                atlas: scatter ? atlas : null,
                                scatterAlpha: _reduced
                                    ? PageBackground.reducedScatterAlpha
                                    : PageBackground.scatterAlpha,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (colors.isDark)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _NightSkyPainter(
                        time: _sky,
                        fadeIn: starsIn,
                        color: colors.ink,
                        textColumnWidth: widget.textColumnWidth,
                        gutter: MediaQuery.sizeOf(context).width < 600
                            ? 20
                            : 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!scatter)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _SymbolPainter(
                        field: _field,
                        atlas: atlas,
                        alpha: PageBackground.symbolAlpha(colors),
                        life: _life,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

class _Symbol {
  _Symbol({required this.glyph, required this.centre, required this.born});

  final int glyph;
  final Offset centre;
  final Duration born;
}

class _SymbolField extends ChangeNotifier {
  final symbols = <_Symbol>[];
  Duration now = Duration.zero;

  void changed() => notifyListeners();
}

/// Every symbol rasterised once, side by side, into one small image. Painting
/// a symbol is then a single drawImageRect with an alpha, with no text
/// layout per frame.
class _GlyphAtlas {
  factory _GlyphAtlas({
    required Color color,
    required double pixelRatio,
    required int fontGeneration,
  }) {
    const gap = 4.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    final sizes = <Size>[];
    final sources = <Rect>[];
    var x = 0.0;
    var height = 0.0;
    for (final symbol in codeSymbols) {
      final painter = TextPainter(
        text: TextSpan(
          text: symbol,
          style: TextStyle(
            fontFamily: AppFonts.mono,
            fontSize: 13,
            height: 1,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x, 0));
      final size = painter.size;
      sizes.add(size);
      sources.add(
        Rect.fromLTWH(
          x * pixelRatio,
          0,
          size.width * pixelRatio,
          size.height * pixelRatio,
        ),
      );
      height = math.max(height, size.height);
      x += size.width + gap;
      painter.dispose();
    }
    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      math.max(1, (x * pixelRatio).ceil()),
      math.max(1, (height * pixelRatio).ceil()),
    );
    picture.dispose();
    return _GlyphAtlas._(
      image: image,
      sizes: sizes,
      sources: sources,
      color: color,
      pixelRatio: pixelRatio,
      fontGeneration: fontGeneration,
    );
  }

  _GlyphAtlas._({
    required this.image,
    required this.sizes,
    required this.sources,
    required this.color,
    required this.pixelRatio,
    required this.fontGeneration,
  });

  final ui.Image image;
  final List<Size> sizes;
  final List<Rect> sources;
  final Color color;
  final double pixelRatio;
  final int fontGeneration;

  final _paint = Paint()..filterQuality = FilterQuality.low;

  void draw(Canvas canvas, int glyph, Offset centre, double alpha) {
    final size = sizes[glyph];
    canvas.drawImageRect(
      image,
      sources[glyph],
      Rect.fromCenter(center: centre, width: size.width, height: size.height),
      _paint..color = Color.fromRGBO(0, 0, 0, alpha),
    );
  }

  void dispose() => image.dispose();
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.dot,
    required this.atlas,
    required this.scatterAlpha,
  });

  final Color dot;

  /// Draws the fixed symbol scatter when set.
  final _GlyphAtlas? atlas;
  final double scatterAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    const step = PageBackground.spacing;
    final points = <Offset>[];
    for (var y = step / 2; y < size.height; y += step) {
      for (var x = step / 2; x < size.width; x += step) {
        points.add(Offset(x, y));
      }
    }
    // One draw call for the whole grid.
    canvas.drawPoints(
      ui.PointMode.points,
      points,
      Paint()
        ..color = dot
        ..strokeWidth = PageBackground.radius * 2
        ..strokeCap = StrokeCap.round,
    );

    final atlas = this.atlas;
    if (atlas == null) return;
    // About one symbol per 150px cell, a quarter of cells filled, placed
    // between grid dots. Seeded, so the layout is stable across repaints.
    const cell = 150.0;
    final random = math.Random(7);
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        final fill = random.nextDouble() < 0.25;
        final glyph = random.nextInt(codeSymbols.length);
        final dx = (1 + random.nextInt(4)) * step;
        final dy = (1 + random.nextInt(4)) * step;
        if (fill) {
          atlas.draw(canvas, glyph, Offset(x + dx, y + dy), scatterAlpha);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.dot != dot || old.atlas != atlas || old.scatterAlpha != scatterAlpha;
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter({
    required this.field,
    required this.atlas,
    required this.alpha,
    required this.life,
  }) : super(repaint: field);

  final _SymbolField field;
  final _GlyphAtlas atlas;
  final double alpha;
  final Duration life;

  @override
  void paint(Canvas canvas, Size size) {
    for (final symbol in field.symbols) {
      final t = ((field.now - symbol.born).inMicroseconds / life.inMicroseconds)
          .clamp(0.0, 1.0);
      // In over the first 15%, then out; rising 10px over its life.
      final strength = t < 0.15
          ? t / 0.15
          : Curves.easeOut.transform(1 - (t - 0.15) / 0.85);
      if (strength <= 0) continue;
      atlas.draw(
        canvas,
        symbol.glyph,
        symbol.centre - Offset(0, 10 * t),
        alpha * strength,
      );
    }
  }

  @override
  bool shouldRepaint(_SymbolPainter old) =>
      old.field != field || old.atlas != atlas || old.alpha != alpha;
}

class _Star {
  const _Star(this.position, this.radius, this.alpha, this.period, this.phase);

  final Offset position;
  final double radius;
  final double alpha;
  final double period;
  final double phase;
}

/// A few faint stars in the margins either side of the text column.
class _NightSkyPainter extends CustomPainter {
  _NightSkyPainter({
    required this.time,
    required this.fadeIn,
    required this.color,
    required this.textColumnWidth,
    required this.gutter,
  }) : super(repaint: Listenable.merge([time, fadeIn]));

  final ValueListenable<double> time;
  final Animation<double> fadeIn;
  final Color color;
  final double textColumnWidth;
  final double gutter;

  Size? _laidOutFor;
  List<_Star> _stars = const [];

  List<_Star> _layout(Size size) {
    // Text never comes closer than the column's own padding.
    final margin = math.max(0.0, (size.width - textColumnWidth) / 2) + gutter;
    final band = margin - 14;
    if (band < 4) return const [];
    final wide = band > 60;
    final random = math.Random(11);
    final perSide = (size.height / (wide ? 70 : 150)).floor();
    return [
      for (var side = 0; side < 2; side++)
        for (var i = 0; i < perSide; i++)
          () {
            final x = 6 + random.nextDouble() * (band - 6);
            return _Star(
              Offset(
                side == 0 ? x : size.width - x,
                random.nextDouble() * size.height,
              ),
              0.6 + random.nextDouble() * (wide ? 0.8 : 0.4),
              0.25 + random.nextDouble() * 0.3,
              6 + random.nextDouble() * 5,
              random.nextDouble() * 2 * math.pi,
            );
          }(),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_laidOutFor != size) {
      _stars = _layout(size);
      _laidOutFor = size;
    }
    final fade = fadeIn.value;
    if (fade <= 0 || _stars.isEmpty) return;
    final now = time.value;
    final paint = Paint();
    for (final star in _stars) {
      final twinkle =
          0.65 + 0.35 * math.sin(now * 2 * math.pi / star.period + star.phase);
      canvas.drawCircle(
        star.position,
        star.radius,
        paint..color = color.withValues(alpha: star.alpha * twinkle * fade),
      );
    }
  }

  @override
  bool shouldRepaint(_NightSkyPainter old) =>
      old.color != color ||
      old.textColumnWidth != textColumnWidth ||
      old.gutter != gutter ||
      old.time != time ||
      old.fadeIn != fadeIn;
}
