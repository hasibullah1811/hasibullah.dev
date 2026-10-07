import 'package:flutter/material.dart';

import '../theme.dart';

/// The Journey section's motion language, shared by every section.
class Motion {
  /// Fade-and-rise for anything entering the page.
  static const reveal = Duration(milliseconds: 450);

  /// Reveals that also count numbers up (the fade takes the first 30%).
  static const revealWithCount = Duration(milliseconds: 1500);

  /// Lines that draw in (section labels, card rules).
  static const draw = Duration(milliseconds: 700);
  static const hover = Duration(milliseconds: 180);
  static const curve = Curves.easeOut;
  static const drawCurve = Curves.easeOutCubic;

  /// How far content rises while it fades in.
  static const rise = 14.0;

  /// How far a card lifts on hover.
  static const lift = 3.0;

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}

/// Whether [context]'s render box overlaps the viewport, shrunk by
/// [inset] (a fraction of the viewport height) at the bottom.
bool isOnScreen(BuildContext context, {double inset = 0}) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.attached || !box.hasSize) return false;
  final top = box.localToGlobal(Offset.zero).dy;
  final viewport = MediaQuery.sizeOf(context).height;
  return top < viewport * (1 - inset) && top + box.size.height > 0;
}

/// Fades and rises its child once, when it first scrolls into view.
///
/// [builder] also receives the reveal animation (0 to 1 over [duration]) so
/// children can draw lines or count numbers as the section arrives. With
/// reduced motion the animation starts complete.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    this.child,
    this.builder,
    this.duration = Motion.reveal,
    this.delay = Duration.zero,
  }) : assert(child != null || builder != null);

  final Widget? child;
  final Widget Function(BuildContext context, Animation<double> reveal)?
  builder;
  final Duration duration;
  final Duration delay;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0,
      (Motion.reveal.inMilliseconds / widget.duration.inMilliseconds).clamp(
        0,
        1,
      ),
      curve: Motion.curve,
    ),
  );
  ScrollPosition? _position;
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _detach();
      _triggered = true;
      _controller.value = 1;
      return;
    }
    if (_triggered) return;
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _detach();
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _detach() {
    _position?.removeListener(_check);
    _position = null;
  }

  void _check() {
    if (!mounted || _triggered) return;
    // Wait until content is a little way into the viewport, unless the page
    // cannot scroll any further (the last section on a tall screen).
    final position = _position;
    final atEnd =
        position == null ||
        !position.hasContentDimensions ||
        position.pixels >= position.maxScrollExtent - 1;
    if (!isOnScreen(context, inset: atEnd ? 0 : 0.12)) return;
    _triggered = true;
    _detach();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder?.call(context, _controller) ?? widget.child!;
    // Hidden content stays in the semantics tree and stays selectable.
    return FadeTransition(
      opacity: _fade,
      alwaysIncludeSemantics: true,
      child: AnimatedBuilder(
        animation: _fade,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, Motion.rise * (1 - _fade.value)),
          child: child,
        ),
        child: child,
      ),
    );
  }
}

/// An accent rule that draws from left to right as [progress] runs.
class DrawLine extends StatelessWidget {
  const DrawLine({
    super.key,
    required this.progress,
    this.width,
    this.thickness = 2,
    this.color,
    this.start = 0.25,
  });

  final Animation<double> progress;

  /// Full width when drawn; null fills the available width.
  final double? width;
  final double thickness;

  /// Defaults to the theme's accent.
  final Color? color;

  /// Where in [progress] the line starts drawing.
  final double start;

  @override
  Widget build(BuildContext context) {
    final drawn = CurvedAnimation(
      parent: progress,
      curve: Interval(start, 1, curve: Motion.drawCurve),
    );
    return ExcludeSemantics(
      child: SizedBox(
        width: width ?? double.infinity,
        height: thickness,
        child: CustomPaint(
          painter: _LinePainter(drawn, color ?? AppColors.of(context).accent),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.progress, this.color) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress.value <= 0) return;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress.value, size.height),
        Radius.circular(size.height / 2),
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.progress != progress || old.color != color;
}
