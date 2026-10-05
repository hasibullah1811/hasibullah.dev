import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../motion.dart';
import '../widgets/brand_icons.dart';
import '../widgets/common.dart';

/// Availability, name, tagline and links, revealed line by line on load.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.profile});

  final Profile profile;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  // Four lines, each starting 120ms after the last.
  static const _lines = 4;
  static const _stagger = Duration(milliseconds: 120);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.reveal + _stagger * (_lines - 1),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _controller.value = 1;
    } else if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _line(int index) {
    final total = _controller.duration!.inMilliseconds;
    final start = (_stagger * index).inMilliseconds / total;
    final end = start + Motion.reveal.inMilliseconds / total;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end.clamp(0, 1), curve: Motion.curve),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final compact = isCompact(context);
    final cv = profile.cvUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Line(
          animation: _line(0),
          child: _Availability([
            profile.status,
            profile.workRightsShort,
            profile.location,
          ]),
        ),
        const SizedBox(height: 20),
        // The name slides up from behind a clip, like a line of type.
        _Line(
          animation: _line(1),
          clip: true,
          child: Semantics(
            header: true,
            headingLevel: 1,
            child: Text(
              profile.name,
              style: AppText.display.copyWith(fontSize: compact ? 36 : 46),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _Line(
          animation: _line(2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              profile.tagline,
              style: AppText.lead.copyWith(fontSize: compact ? 18 : 20),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _Line(
          animation: _line(3),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (cv != null)
                LinkButton(
                  label: 'Download CV',
                  url: cv,
                  icon: const Icon(Icons.description_outlined, size: 18),
                  primary: true,
                ),
              LinkButton(
                label: 'Email',
                url: 'mailto:${profile.email}',
                icon: const Icon(Icons.mail_outline, size: 18),
                primary: cv == null,
              ),
              LinkButton(
                label: 'LinkedIn',
                url: profile.linkedIn,
                icon: const BrandIcon(Brand.linkedIn, size: 16),
              ),
              LinkButton(
                label: 'GitHub',
                url: profile.github,
                icon: const BrandIcon(Brand.gitHub, size: 16),
              ),
              LinkButton(
                label: 'LeetCode',
                url: profile.leetCode,
                icon: const BrandIcon(Brand.leetCode, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One hero line: fades and rises, or with [clip], slides up into view.
class _Line extends StatelessWidget {
  const _Line({
    required this.animation,
    required this.child,
    this.clip = false,
  });

  final Animation<double> animation;
  final Widget child;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final moving = AnimatedBuilder(
      animation: animation,
      builder: (context, child) => clip
          ? FractionalTranslation(
              translation: Offset(0, 1 - animation.value),
              child: child,
            )
          : Transform.translate(
              offset: Offset(0, Motion.rise * (1 - animation.value)),
              child: child,
            ),
      child: child,
    );
    return FadeTransition(
      opacity: animation,
      alwaysIncludeSemantics: true,
      child: clip ? ClipRect(child: moving) : moving,
    );
  }
}

class _Availability extends StatelessWidget {
  const _Availability(this.parts);

  final List<String> parts;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The ring needs room to grow, so the dot's box is wider than it.
        const _PulseDot(),
        const SizedBox(width: 6),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              parts.join('  ·  '),
              style: AppText.label.copyWith(
                fontSize: 13,
                color: AppColors.available,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A green dot with a ring that pulses outward. Runs only while on screen,
/// the tab is visible and motion is allowed.
class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  late final AppLifecycleListener _lifecycle;
  ScrollPosition? _position;
  bool _reduced = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _update());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = Motion.reduced(context);
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_update);
      _position = position?..addListener(_update);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _update() {
    if (!mounted) return;
    final state = WidgetsBinding.instance.lifecycleState;
    final run =
        !_reduced &&
        state != AppLifecycleState.hidden &&
        state != AppLifecycleState.paused &&
        isOnScreen(context);
    if (run && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!run && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_update);
    _lifecycle.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: CustomPaint(
          size: const Size.square(20),
          painter: _PulsePainter(_pulse),
        ),
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  _PulsePainter(this.pulse) : super(repaint: pulse);

  final Animation<double> pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final t = Curves.easeOut.transform(pulse.value);
    if (t > 0) {
      canvas.drawCircle(
        centre,
        4 + 6 * t,
        Paint()..color = AppColors.available.withValues(alpha: 0.35 * (1 - t)),
      );
    }
    canvas.drawCircle(centre, 4, Paint()..color = AppColors.available);
  }

  @override
  bool shouldRepaint(_PulsePainter old) => old.pulse != pulse;
}
