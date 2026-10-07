import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../motion.dart';
import '../widgets/common.dart';

/// Fades and slides its child in once, when the route line reaches
/// [revealAt] (in section coordinates). [builder] also receives the reveal
/// animation so metrics can count up as the card arrives.
class RevealOnce extends StatefulWidget {
  const RevealOnce({
    super.key,
    required this.drawY,
    required this.revealAt,
    required this.reduced,
    required this.builder,
  });

  final ValueNotifier<double> drawY;

  /// Returns null until the section has been measured.
  final double? Function() revealAt;
  final bool reduced;
  final Widget Function(BuildContext context, Animation<double> reveal) builder;

  @override
  State<RevealOnce> createState() => _RevealOnceState();
}

class _RevealOnceState extends State<RevealOnce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.revealWithCount,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.3, curve: Motion.curve),
  );

  @override
  void initState() {
    super.initState();
    if (widget.reduced) {
      _controller.value = 1;
    } else {
      widget.drawY.addListener(_check);
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    }
  }

  void _check() {
    final at = widget.revealAt();
    if (!mounted || at == null || widget.drawY.value < at) return;
    widget.drawY.removeListener(_check);
    _controller.forward();
  }

  @override
  void didUpdateWidget(RevealOnce old) {
    super.didUpdateWidget(old);
    if (widget.reduced && _controller.value < 1) {
      widget.drawY.removeListener(_check);
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    widget.drawY.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _controller);
    return AnimatedBuilder(
      animation: _fade,
      // Hidden cards stay in the semantics tree for screen readers.
      builder: (context, child) => Opacity(
        opacity: _fade.value,
        alwaysIncludeSemantics: true,
        child: Transform.translate(
          offset: Offset(0, Motion.rise * (1 - _fade.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class StopContent extends StatelessWidget {
  const StopContent({super.key, required this.stop, required this.reveal});

  final JourneyStop stop;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    final organisation = stop.organisation;
    final detail = stop.detail;
    final c = AppColors.of(context);
    final text = AppText.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: stop.period,
                style: text.label.copyWith(color: c.accent),
              ),
              TextSpan(text: '  ·  ${stop.place}'),
            ],
          ),
          style: text.label,
        ),
        const SizedBox(height: 6),
        Text(stop.title, style: text.title),
        if (organisation != null)
          Text(organisation, style: text.body.copyWith(color: c.muted)),
        if (detail != null) ...[
          const SizedBox(height: 4),
          Text(detail, style: text.body),
        ],
        if (stop.metrics.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 28,
            runSpacing: 10,
            children: [
              for (final metric in stop.metrics)
                CountUpMetric(metric: metric, reveal: reveal),
            ],
          ),
        ],
        if (stop.bullets.isNotEmpty) ...[
          const SizedBox(height: 12),
          BulletList(stop.bullets),
        ],
        if (stop.stack.isNotEmpty) ...[
          const SizedBox(height: 12),
          TagList(stop.stack),
        ],
      ],
    );
  }
}

/// Counts up from zero as its card or section is revealed. The final value reserves
/// the width, so the layout never shifts while counting.
class CountUpMetric extends StatelessWidget {
  const CountUpMetric({super.key, required this.metric, required this.reveal});

  final Metric metric;
  final Animation<double> reveal;

  static const _numberStyle = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w600,
    fontSize: 26,
    height: 1.1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @override
  Widget build(BuildContext context) {
    final numberStyle = _numberStyle.copyWith(color: AppColors.of(context).ink);
    final count = CurvedAnimation(
      parent: reveal,
      curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
    );
    final finalText = metric.formatAt(1);

    return Semantics(
      label: '$finalText ${metric.label}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // One line always; scales down rather than wrap in a narrow card.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                SelectionContainer.disabled(
                  child: Visibility.maintain(
                    visible: false,
                    child: Text(finalText, style: numberStyle, maxLines: 1),
                  ),
                ),
                AnimatedBuilder(
                  animation: count,
                  builder: (context, _) => Text(
                    metric.formatAt(count.value),
                    style: numberStyle,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            style: AppText.of(context).label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}
