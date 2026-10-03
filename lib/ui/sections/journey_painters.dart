import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../theme.dart';

/// Measured positions of the journey rows, in the section's local coordinates,
/// and the route path built from them.
class JourneyGeometry {
  JourneyGeometry({
    required this.spineX,
    required this.originY,
    required this.destinationY,
    required this.moveTop,
    required this.moveBottom,
    required this.bulge,
    required this.nodes,
    required this.height,
    this.span,
  }) {
    final h = moveBottom - moveTop;
    path = Path()
      ..moveTo(spineX, originY)
      ..lineTo(spineX, moveTop)
      ..cubicTo(
        spineX + bulge * 1.33,
        moveTop + h * 0.2,
        spineX + bulge * 1.33,
        moveBottom - h * 0.2,
        spineX,
        moveBottom,
      )
      ..lineTo(spineX, destinationY);
    metric = path.computeMetrics().first;
    dashStart = moveTop - originY;
    dashEnd = metric.length - (destinationY - moveBottom);
    for (var d = dashStart; d <= dashEnd; d += 2) {
      _arcSamples.add(metric.getTangentForOffset(d)!.position.dy);
    }
  }

  final double spineX;
  final double originY;
  final double destinationY;
  final double moveTop;
  final double moveBottom;
  final double bulge;
  final List<JourneyNode> nodes;
  final double height;
  final JourneySpanGeometry? span;

  late final Path path;
  late final PathMetric metric;

  /// The dashed "flight" arc across the move, as distances along [path].
  late final double dashStart;
  late final double dashEnd;
  final List<double> _arcSamples = [];

  /// Distance along the route at which it reaches [y].
  double distanceForY(double y) {
    if (y <= originY) return 0;
    if (y <= moveTop) return y - originY;
    if (y >= destinationY) return metric.length;
    if (y >= moveBottom) return dashEnd + (y - moveBottom);
    var lo = 0, hi = _arcSamples.length - 1;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (_arcSamples[mid] < y) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return math.min(dashStart + lo * 2, dashEnd);
  }

  bool sameLayout(JourneyGeometry? other) {
    if (other == null ||
        other.nodes.length != nodes.length ||
        (other.height - height).abs() > 0.5 ||
        other.spineX != spineX ||
        (other.moveTop - moveTop).abs() > 0.5) {
      return false;
    }
    for (var i = 0; i < nodes.length; i++) {
      if ((other.nodes[i].y - nodes[i].y).abs() > 0.5) return false;
    }
    return true;
  }
}

class JourneyNode {
  const JourneyNode(this.y, {this.chapter = false});

  final double y;
  final bool chapter;
}

class JourneySpanGeometry {
  const JourneySpanGeometry({
    required this.x,
    required this.top,
    required this.bottom,
    required this.hookTo,
  });

  final double x;
  final double top;
  final double bottom;

  /// The bar ends in a small hook pointing at its note, ending at this x.
  final double hookTo;
}

/// Draws the route, nodes, part-time bar and travelling dot. Repaints on
/// scroll without rebuilding any widgets.
class RoutePainter extends CustomPainter {
  RoutePainter({
    required this.geometry,
    required this.drawY,
    required this.reduced,
  }) : super(repaint: Listenable.merge([geometry, drawY]));

  final ValueNotifier<JourneyGeometry?> geometry;
  final ValueNotifier<double> drawY;
  final bool reduced;

  static final _track = Paint()
    ..color = AppColors.line
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  static final _progress = Paint()
    ..color = AppColors.accent
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final g = geometry.value;
    if (g == null) return;
    final y = reduced ? g.height : drawY.value;
    final reached = g.distanceForY(y);

    _route(canvas, g, g.metric.length, _track);
    _route(canvas, g, reached, _progress);

    final span = g.span;
    if (span != null) _spanBar(canvas, span, y);

    for (final node in g.nodes) {
      _node(canvas, Offset(g.spineX, node.y), node, y >= node.y);
    }

    if (!reduced && reached > 0 && reached < g.metric.length) {
      _glow(canvas, g.metric.getTangentForOffset(reached)!.position);
    }
  }

  void _route(Canvas canvas, JourneyGeometry g, double to, Paint paint) {
    final m = g.metric;
    canvas.drawPath(m.extractPath(0, math.min(to, g.dashStart)), paint);
    for (var d = g.dashStart; d < math.min(to, g.dashEnd); d += 9) {
      canvas.drawPath(
        m.extractPath(d, math.min(d + 4.5, math.min(to, g.dashEnd))),
        paint,
      );
    }
    if (to > g.dashEnd) {
      canvas.drawPath(m.extractPath(g.dashEnd, to), paint);
    }
  }

  void _spanBar(Canvas canvas, JourneySpanGeometry s, double y) {
    final bar = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final hook = Path()
      ..moveTo(s.x, s.top)
      ..lineTo(s.x, s.bottom - 8)
      ..quadraticBezierTo(s.x, s.bottom, s.x + 8, s.bottom)
      ..lineTo(s.hookTo, s.bottom);
    canvas.drawPath(hook, bar..color = AppColors.accentSoft);
    if (y > s.top) {
      final metric = hook.computeMetrics().first;
      final reached = (y - s.top).clamp(0.0, metric.length);
      canvas.drawPath(
        metric.extractPath(0, reached),
        bar
          ..color = AppColors.accent.withValues(alpha: 0.55)
          ..strokeWidth = 2,
      );
    }
  }

  void _node(Canvas canvas, Offset c, JourneyNode node, bool lit) {
    final radius = node.chapter ? 8.0 : 5.5;
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..color = lit && !node.chapter ? AppColors.accent : AppColors.paper,
    );
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = lit ? AppColors.accent : AppColors.line,
    );
    if (node.chapter && lit) {
      canvas.drawCircle(c, 3, Paint()..color = AppColors.accent);
    }
  }

  void _glow(Canvas canvas, Offset c) {
    canvas.drawCircle(
      c,
      14,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.35),
            AppColors.accent.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: 14)),
    );
    canvas.drawCircle(c, 4.5, Paint()..color = AppColors.accent);
    canvas.drawCircle(
      c,
      4.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.paper,
    );
  }

  @override
  bool shouldRepaint(RoutePainter old) =>
      old.reduced != reduced || old.geometry != geometry || old.drawY != drawY;
}

/// Faint topographic contour lines that drift slowly. Kept at roughly 1.15:1
/// against the paper colour so they never compete with text.
class ContourPainter extends CustomPainter {
  ContourPainter(this.drift) : super(repaint: drift);

  final Animation<double> drift;

  static final _stroke = Paint()
    ..color = AppColors.line.withValues(alpha: 0.6)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  Size? _cachedSize;
  List<Path> _paths = const [];

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedSize != size) {
      _paths = _contours(size);
      _cachedSize = size;
    }
    final angle = drift.value * 2 * math.pi;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(16 * math.sin(angle), 10 * math.cos(angle));
    for (final path in _paths) {
      canvas.drawPath(path, _stroke);
    }
    canvas.restore();
    _fadeEdges(canvas, size);
  }

  /// Fades the lines into the paper at every edge instead of a hard clip.
  /// Plain gradient rects, so no offscreen layer is needed each frame.
  static void _fadeEdges(Canvas canvas, Size size) {
    const fade = 72.0;
    const clear = Color(0x00FAF7F2);
    void edge(Rect rect, Alignment from, Alignment to) => canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: from,
          end: to,
          colors: const [AppColors.paper, clear],
        ).createShader(rect),
    );
    edge(
      Rect.fromLTWH(0, 0, fade, size.height),
      Alignment.centerLeft,
      Alignment.centerRight,
    );
    edge(
      Rect.fromLTWH(size.width - fade, 0, fade, size.height),
      Alignment.centerRight,
      Alignment.centerLeft,
    );
    edge(
      Rect.fromLTWH(0, 0, size.width, fade),
      Alignment.topCenter,
      Alignment.bottomCenter,
    );
    edge(
      Rect.fromLTWH(0, size.height - fade, size.width, fade),
      Alignment.bottomCenter,
      Alignment.topCenter,
    );
  }

  static List<Path> _contours(Size size) {
    final centres = [
      Offset(size.width * 0.92, size.height * 0.12),
      Offset(size.width * 0.05, size.height * 0.55),
      Offset(size.width * 0.85, size.height * 0.9),
    ];
    final paths = <Path>[];
    for (var c = 0; c < centres.length; c++) {
      for (var k = 0; k < 7; k++) {
        final base = 44.0 + k * 36;
        final path = Path();
        for (var i = 0; i <= 96; i++) {
          final t = i / 96 * 2 * math.pi;
          final r =
              base *
              (1 +
                  0.09 * math.sin(3 * t + k * 0.7 + c) +
                  0.05 * math.sin(5 * t + k * 1.3 + c * 2));
          final p = centres[c] + Offset(math.cos(t) * r, math.sin(t) * r * 0.8);
          i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
        }
        paths.add(path..close());
      }
    }
    return paths;
  }

  @override
  bool shouldRepaint(ContourPainter old) => old.drift != drift;
}
