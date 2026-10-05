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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(eyebrow: 'About', title: about.title),
        ScrollReveal(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(about.text, style: AppText.lead.copyWith(fontSize: 17)),
          ),
        ),
        const SizedBox(height: 28),
        ScrollReveal(
          duration: Motion.revealWithCount,
          builder: (context, reveal) => LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 600 ? 4 : 2;
              const gap = 12.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final metric in about.metrics)
                    SizedBox(
                      width: width,
                      child: LiftCard(
                        padding: const EdgeInsets.all(16),
                        child: CountUpMetric(metric: metric, reveal: reveal),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
