import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../motion.dart';
import '../widgets/common.dart';
import 'journey_cards.dart';

/// Who I am in one paragraph, then the key numbers, which count up once
/// when they scroll into view.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.about});

  final About about;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(eyebrow: 'About', title: about.title),
        ScrollReveal(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(about.text, style: text.lead.copyWith(fontSize: 17)),
          ),
        ),
        const SizedBox(height: 28),
        ScrollReveal(
          duration: Motion.revealWithCount,
          builder: (context, reveal) => LayoutBuilder(
            builder: (context, constraints) => EqualGrid(
              columns: constraints.maxWidth >= 600 ? 4 : 2,
              children: [
                for (final metric in about.metrics)
                  LiftCard(
                    child: CountUpMetric(metric: metric, reveal: reveal),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
