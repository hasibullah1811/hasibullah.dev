import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../widgets/common.dart';

/// The journey as a route line. The accent line draws itself once when the
/// section scrolls into view; with reduced motion it is drawn immediately.
class JourneySection extends StatefulWidget {
  const JourneySection({super.key, required this.stops});

  final List<JourneyStop> stops;

  @override
  State<JourneySection> createState() => _JourneySectionState();
}

class _JourneySectionState extends State<JourneySection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (MediaQuery.disableAnimationsOf(context) || position == null) {
      _detach();
      _controller.value = 1;
      return;
    }
    if (position != _position) {
      _detach();
      _position = position..addListener(_startWhenVisible);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _startWhenVisible());
  }

  void _startWhenVisible() {
    if (!mounted || _controller.value > 0 || _controller.isAnimating) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.8) {
      _detach();
      _controller.forward();
    }
  }

  void _detach() {
    _position?.removeListener(_startWhenVisible);
    _position = null;
  }

  @override
  void dispose() {
    _detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stops = widget.stops;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'Journey',
          title: 'From Dhaka to Wollongong',
        ),
        AnimatedBuilder(
          animation: _progress,
          builder: (context, _) => Column(
            children: [
              for (var i = 0; i < stops.length; i++)
                _StopRow(
                  stop: stops[i],
                  isLast: i == stops.length - 1,
                  fraction: (_progress.value * stops.length - i).clamp(0, 1),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.stop,
    required this.isLast,
    required this.fraction,
  });

  final JourneyStop stop;
  final bool isLast;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final organisation = stop.organisation;
    final detail = stop.detail;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: ExcludeSemantics(
              child: CustomPaint(
                painter: _RailPainter(fraction: fraction, isLast: isLast),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: stop.period,
                          style: AppText.label.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        TextSpan(text: '  ·  ${stop.place}'),
                      ],
                    ),
                    style: AppText.label,
                  ),
                  const SizedBox(height: 4),
                  Text(stop.title, style: AppText.title),
                  if (organisation != null)
                    Text(
                      organisation,
                      style: AppText.body.copyWith(color: AppColors.muted),
                    ),
                  if (detail != null) ...[
                    const SizedBox(height: 4),
                    Text(detail, style: AppText.body),
                  ],
                  if (stop.bullets.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    BulletList(stop.bullets),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailPainter extends CustomPainter {
  _RailPainter({required this.fraction, required this.isLast});

  final double fraction;
  final bool isLast;

  static const _dotY = 9.0;
  static const _radius = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final lit = fraction > 0;

    if (!isLast) {
      final track = Paint()
        ..color = AppColors.line
        ..strokeWidth = 2;
      canvas.drawLine(Offset(x, _dotY), Offset(x, size.height + _dotY), track);
      if (lit) {
        final end = _dotY + (size.height) * fraction;
        canvas.drawLine(
          Offset(x, _dotY),
          Offset(x, end),
          track..color = AppColors.accent,
        );
      }
    }

    canvas.drawCircle(
      const Offset(0, _dotY).translate(x, 0),
      _radius,
      Paint()..color = lit ? AppColors.accent : AppColors.paper,
    );
    canvas.drawCircle(
      const Offset(0, _dotY).translate(x, 0),
      _radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = lit ? AppColors.accent : AppColors.line,
    );
  }

  @override
  bool shouldRepaint(_RailPainter old) =>
      old.fraction != fraction || old.isLast != isLast;
}
