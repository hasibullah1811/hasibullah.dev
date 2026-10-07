import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme.dart';
import '../motion.dart';

/// The light/dark switch: a sun above a horizon in light mode, a crescent
/// moon and three small stars in dark mode. Switching sinks one below the
/// horizon as the other rises, over 600ms.
///
/// [onPressed] gets the button's centre in global coordinates, where the
/// page transition starts. Null disables the button.
class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key, required this.dark, required this.onPressed});

  final bool dark;
  final void Function(Offset centre)? onPressed;

  static const duration = Duration(milliseconds: 600);

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ThemeToggle.duration,
    value: widget.dark ? 1 : 0,
  );
  late final Animation<double> _night = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void didUpdateWidget(ThemeToggle old) {
    super.didUpdateWidget(old);
    if (old.dark == widget.dark) return;
    if (Motion.reduced(context)) {
      _controller.value = widget.dark ? 1 : 0;
    } else if (widget.dark) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _press() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    widget.onPressed?.call(box.localToGlobal(box.size.center(Offset.zero)));
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final label = widget.dark ? 'Switch to light mode' : 'Switch to dark mode';
    // No Tooltip: this sits above the Navigator, outside any Overlay. The
    // label is in the semantics tree for screen readers.
    return IconButton(
      onPressed: widget.onPressed == null ? null : _press,
      style:
          IconButton.styleFrom(
            minimumSize: const Size(44, 44),
            backgroundColor: c.surface,
            disabledBackgroundColor: c.surface,
            side: BorderSide(color: c.lineStrong),
            hoverColor: c.tint,
          ).copyWith(
            side: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? BorderSide(color: c.accent, width: 2)
                  : BorderSide(color: c.lineStrong),
            ),
          ),
      icon: Semantics(
        label: label,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size.square(24),
            painter: _SkyPainter(_night, c),
          ),
        ),
      ),
    );
  }
}

/// Drawn on a 24×24 grid. [night] runs 0 (sun up) to 1 (moon up).
class _SkyPainter extends CustomPainter {
  _SkyPainter(this.night, this.colors) : super(repaint: night);

  final Animation<double> night;
  final AppColors colors;

  static const _horizon = 17.0;

  /// A crescent centred on the origin, built once.
  static final _moon = Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 5)),
    Path()
      ..addOval(Rect.fromCircle(center: const Offset(2.6, -2.2), radius: 4.2)),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final t = night.value;
    canvas.scale(size.width / 24, size.height / 24);

    // Sun and moon are hidden below the horizon line.
    canvas.save();
    canvas.clipRect(const Rect.fromLTRB(0, 0, 24, _horizon - 0.8));

    // The sun sinks from 11.5 to below the horizon as t runs to 1.
    final sunY = 11.5 + 13 * t;
    final sun = Offset(12, sunY);
    final sunPaint = Paint()..color = colors.accent;
    canvas.drawCircle(sun, 3.6, sunPaint);
    final rays = Paint()
      ..color = colors.accent
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final d = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(sun + d * 5.4, sun + d * 6.9, rays);
    }

    // The moon rises from below the horizon to 10.5.
    final moonY = 24.5 - 14 * t;
    canvas.drawPath(
      _moon.shift(Offset(12, moonY)),
      Paint()..color = colors.ink,
    );
    canvas.restore();

    // Stars come out as the moon clears the horizon.
    final stars = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
    if (stars > 0) {
      final star = Paint()..color = colors.ink.withValues(alpha: stars);
      canvas.drawCircle(const Offset(4.5, 5), 0.9, star);
      canvas.drawCircle(const Offset(19.5, 3.5), 0.75, star);
      canvas.drawCircle(const Offset(20, 10), 0.6, star);
    }

    canvas.drawLine(
      const Offset(2.5, _horizon),
      const Offset(21.5, _horizon),
      Paint()
        ..color = colors.muted
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SkyPainter old) =>
      old.night != night || old.colors != colors;
}
