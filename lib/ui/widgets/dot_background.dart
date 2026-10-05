import 'dart:math' as math;
import 'dart:ui' show PointMode;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../motion.dart';

/// A faint dot grid fixed to the viewport, behind the whole page.
///
/// - Base dots are ink at 7%. Near a mouse pointer they tint toward the
///   accent, never past the alpha checked in theme.dart, so text that
///   happens to sit on a dot keeps at least 4.5:1.
/// - On touch devices the grid drifts slowly instead. The drift only moves
///   a cached layer (a transform), so it never repaints the dots.
/// - Paused while the tab is hidden; static with reduced motion.
class DotBackground extends StatefulWidget {
  const DotBackground({super.key, required this.child});

  final Widget child;

  static const spacing = 24.0;
  static const radius = 1.0;
  static const baseAlpha = 0.07;

  /// Extra accent alpha at the pointer. Keep in sync with theme.dart's
  /// contrast note.
  static const glowAlpha = 0.12;
  static const glowRadius = 140.0;

  @override
  State<DotBackground> createState() => _DotBackgroundState();
}

class _DotBackgroundState extends State<DotBackground>
    with TickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: Motion.hover,
  );
  final _pointer = ValueNotifier<Offset?>(null);
  late final AppLifecycleListener _lifecycle;

  bool _reduced = false;

  // Mobile browsers report a touch platform; a real mouse turns drift off.
  bool _touch =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _updateDrift());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = Motion.reduced(context);
    _updateDrift();
  }

  void _updateDrift() {
    final visible =
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.hidden &&
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.paused;
    final run = _touch && !_reduced && visible;
    if (run && !_drift.isAnimating) {
      _drift.repeat();
    } else if (!run && _drift.isAnimating) {
      _drift.stop();
    }
  }

  void _onHover(PointerHoverEvent event) {
    if (_reduced) return;
    if (_touch) {
      _touch = false;
      _updateDrift();
    }
    _pointer.value = event.localPosition;
    if (_glow.status != AnimationStatus.forward && _glow.value < 1) {
      _glow.forward();
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_reduced) return;
    _glow.reverse();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _drift.dispose();
    _glow.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onHover: _onHover,
      onExit: _onExit,
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
                      const step = DotBackground.spacing;
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
                                size.width + DotBackground.spacing * 2,
                                size.height + DotBackground.spacing * 2,
                              ),
                              painter: const _GridPainter(),
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
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _GlowPainter(pointer: _pointer, glow: _glow),
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

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const step = DotBackground.spacing;
    final paint = Paint()
      ..color = AppColors.ink.withValues(alpha: DotBackground.baseAlpha);
    final points = <Offset>[];
    for (var y = step / 2; y < size.height; y += step) {
      for (var x = step / 2; x < size.width; x += step) {
        points.add(Offset(x, y));
      }
    }
    // One draw call for the whole grid.
    canvas.drawPoints(
      PointMode.points,
      points,
      paint
        ..strokeWidth = DotBackground.radius * 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

/// Tints the few dots near the pointer. Grid-aligned with [_GridPainter],
/// which only drifts on touch devices, where there is no pointer.
class _GlowPainter extends CustomPainter {
  _GlowPainter({required this.pointer, required this.glow})
    : super(repaint: Listenable.merge([pointer, glow]));

  final ValueNotifier<Offset?> pointer;
  final Animation<double> glow;

  @override
  void paint(Canvas canvas, Size size) {
    final p = pointer.value;
    if (p == null || glow.value == 0) return;
    const step = DotBackground.spacing;
    const r = DotBackground.glowRadius;
    // At rest the grid layer sits one step up and left, so on screen dot
    // centres are still at step / 2 + k * step.
    double first(double v) =>
        ((v - r - step / 2) / step).ceil() * step + step / 2;
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var y = first(p.dy); y <= p.dy + r; y += step) {
      for (var x = first(p.dx); x <= p.dx + r; x += step) {
        final d = (Offset(x, y) - p).distance;
        if (d >= r) continue;
        final t = 1 - d / r;
        final strength = t * t * glow.value;
        paint
          ..color = AppColors.accent.withValues(
            alpha: DotBackground.glowAlpha * strength,
          )
          ..strokeWidth = (DotBackground.radius + 0.4 * strength) * 2;
        canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GlowPainter old) =>
      old.pointer != pointer || old.glow != glow;
}
