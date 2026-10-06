import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../platform/browser.dart' as browser;
import '../theme.dart';
import 'motion.dart';
import 'theme_controller.dart';
import 'widgets/theme_toggle.dart';

/// Wraps the whole app (from MaterialApp.builder) and switches themes with
/// a "sunset" reveal:
///
/// 1. The page, inside a [RepaintBoundary], is captured to an image. This
///    uses toImageSync, which keeps the image on the GPU (no read-back) and
///    lets the capture and the theme switch land in the same frame.
/// 2. That screenshot is shown on top and the theme switches underneath.
///    The full rebuild happens in this frame, while nothing moves yet.
/// 3. From the next frame, a circle grows from the toggle, revealing the
///    new theme and clipping the old screenshot away, with a thin
///    dusk-coloured ring on its edge. Going dark, the stars fade in over the
///    last 300ms. Then the image is disposed.
///
/// Reduced motion, or a failed capture, gets a 250ms crossfade instead.
/// Taps are ignored until the transition ends. Nothing plays on first load
/// or when the system theme changes.
class ThemeTransitionHost extends StatefulWidget {
  const ThemeTransitionHost({
    super.key,
    required this.controller,
    required this.textColumnWidth,
    required this.child,
  });

  final ThemeController controller;

  /// The toggle sits beside the column when there is room for it.
  final double textColumnWidth;
  final Widget child;

  static const duration = Duration(milliseconds: 800);

  /// Never capture above this many device pixels per logical pixel.
  static const maxCaptureRatio = 2.0;

  @override
  State<ThemeTransitionHost> createState() => _ThemeTransitionHostState();
}

class _ThemeTransitionHostState extends State<ThemeTransitionHost>
    with SingleTickerProviderStateMixin {
  final _boundary = GlobalKey();
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: ThemeTransitionHost.duration,
    // Complete at rest, so stars show at full strength on a dark first load.
    value: 1,
  )..addStatusListener(_onRevealStatus);
  late final Animation<double> _eased = CurvedAnimation(
    parent: _reveal,
    curve: Curves.easeInOutCubic,
  );
  late final Animation<double> _starsIn = CurvedAnimation(
    parent: _reveal,
    // The last 300ms of 800.
    curve: const Interval(500 / 800, 1, curve: Curves.easeOut),
  );

  ui.Image? _snapshot;
  Offset _origin = Offset.zero;
  bool _toDark = true;
  bool _busy = false;
  Brightness? _documentBrightness;

  // The toggle joins the tree after the first frame. A focusable node beside
  // the Navigator before the first layout trips Flutter's initial-focus sort
  // when the browser focuses the view on load (it reads the route's size).
  bool _showToggle = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showToggle = true);
    });
  }

  void _onRevealStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _snapshot == null) return;
    final image = _snapshot;
    setState(() {
      _snapshot = null;
      _busy = false;
    });
    // Free the screenshot once the frame without it has been drawn.
    SchedulerBinding.instance.addPostFrameCallback((_) => image?.dispose());
  }

  void _toggle(Offset origin) {
    if (_busy) return;
    final current = Theme.of(context).brightness;
    final target = current == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    final image = Motion.reduced(context) ? null : _capture();
    if (image == null) {
      _crossfade(target);
      return;
    }

    setState(() {
      _snapshot = image;
      _origin = origin;
      _toDark = target == Brightness.dark;
      _busy = true;
    });
    // Rebuilds the app in the new theme this frame, under the screenshot.
    widget.controller.choose(target);
    _reveal.value = 0;
    // Start moving only after that heavy frame, so the first visible step
    // of the reveal isn't a dropped frame.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reveal.forward(from: 0);
    });
  }

  void _crossfade(Brightness target) {
    setState(() => _busy = true);
    widget.controller.choose(target, crossfade: true);
    Future.delayed(ThemeController.crossfadeDuration, () {
      if (mounted) setState(() => _busy = false);
    });
  }

  ui.Image? _capture() {
    try {
      final box = _boundary.currentContext?.findRenderObject();
      if (box is! RenderRepaintBoundary || !box.hasSize) return null;
      // Debug builds assert the boundary is freshly painted; release uses
      // the last composited frame either way.
      if (kDebugMode && box.debugNeedsPaint) return null;
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final cap = browser.isLowEndDevice
          ? 1.0
          : ThemeTransitionHost.maxCaptureRatio;
      final image = box.toImageSync(pixelRatio: math.min(dpr, cap));
      if (image.width == 0 || image.height == 0) {
        image.dispose();
        return null;
      }
      return image;
    } catch (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'theme transition',
          context: ErrorDescription('capturing the page for the reveal'),
          silent: true,
        ),
      );
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keep the browser's background and theme-color in step with the app,
    // whether the theme came from the toggle or the system.
    final colors = AppColors.of(context);
    if (colors.brightness != _documentBrightness) {
      _documentBrightness = colors.brightness;
      browser.applyDocumentTheme(
        dark: colors.isDark,
        paper: colors.paper.toARGB32(),
      );
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    _snapshot?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    // Top right beside the column on wide screens; bottom right on narrow
    // ones, where the top right would cover the navigation.
    final beside = size.width >= widget.textColumnWidth + 2 * 72;
    final snapshot = _snapshot;

    return ThemeTransitionScope(
      starsIn: _starsIn,
      child: Stack(
        children: [
          RepaintBoundary(key: _boundary, child: widget.child),
          if (snapshot != null)
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: _RevealPainter(
                      image: snapshot,
                      origin: _origin,
                      progress: _eased,
                      toDark: _toDark,
                    ),
                  ),
                ),
              ),
            ),
          // Swallows taps and scrolls mid-transition so a double tap can't
          // start a second one.
          if (_busy) const Positioned.fill(child: AbsorbPointer()),
          if (_showToggle)
            Positioned(
              // Keyed: the overlay and AbsorbPointer are inserted before it,
              // and without a key the toggle would lose its state (and its
              // sunset animation) when they appear.
              key: const ValueKey('theme-toggle'),
              right: 16 + padding.right,
              top: beside ? 16 + padding.top : null,
              bottom: beside ? null : 16 + padding.bottom,
              child: ThemeToggle(
                dark: colors.isDark,
                onPressed: _busy ? null : _toggle,
              ),
            ),
        ],
      ),
    );
  }
}

/// Gives the page background the stars' fade-in, which runs over the last
/// 300ms of a reveal into dark mode and is complete at all other times.
class ThemeTransitionScope extends InheritedWidget {
  const ThemeTransitionScope({
    super.key,
    required this.starsIn,
    required super.child,
  });

  final Animation<double> starsIn;

  static Animation<double> starsOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ThemeTransitionScope>()
          ?.starsIn ??
      kAlwaysCompleteAnimation;

  @override
  bool updateShouldNotify(ThemeTransitionScope old) => old.starsIn != starsIn;
}

/// The old-theme screenshot outside a growing circle, with a soft dusk (or
/// dawn) ring on the circle's edge.
class _RevealPainter extends CustomPainter {
  _RevealPainter({
    required this.image,
    required this.origin,
    required this.progress,
    required this.toDark,
  }) : super(repaint: progress);

  final ui.Image image;
  final Offset origin;
  final Animation<double> progress;
  final bool toDark;

  /// Width of the coloured edge, in logical pixels.
  static const ring = 44.0;

  // Dusk: a warm front fading to violet behind it. Dawn: rose to pale gold.
  static const _dusk = [
    Color(0x00433A7A),
    Color(0x55433A7A),
    Color(0x99E07A4F),
  ];
  static const _dawn = [
    Color(0x00F6D58E),
    Color(0x66F6D58E),
    Color(0x99F2A08A),
  ];

  final _imagePaint = Paint()..filterQuality = FilterQuality.low;
  final _ringPaint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final far = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ].map((c) => (c - origin).distance).reduce(math.max);
    final radius = (far + ring) * progress.value;

    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(Rect.fromCircle(center: origin, radius: radius));
    canvas.save();
    canvas.clipPath(outside);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Offset.zero & size,
      _imagePaint,
    );
    canvas.restore();

    if (radius <= 1) return;
    // The ring sits just inside the edge: transparent, then the cool
    // colour, then the warm front right at the edge.
    final width = math.min(ring, radius);
    final inner = (radius - width) / radius;
    final colours = toDark ? _dusk : _dawn;
    _ringPaint
      ..strokeWidth = width
      ..shader = ui.Gradient.radial(origin, radius, colours, [
        inner,
        inner + (1 - inner) * 0.55,
        1,
      ]);
    canvas.drawCircle(origin, radius - width / 2, _ringPaint);
  }

  @override
  bool shouldRepaint(_RevealPainter old) =>
      old.image != image ||
      old.origin != origin ||
      old.progress != progress ||
      old.toDark != toDark;
}
