import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../widgets/common.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    final cv = profile.cvUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusBadge(profile.status),
        const SizedBox(height: 20),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(
            profile.name,
            style: AppText.display.copyWith(fontSize: compact ? 36 : 46),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile.title,
          style: AppText.lead.copyWith(
            fontSize: compact ? 20 : 22,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            profile.summary,
            style: AppText.lead.copyWith(fontSize: compact ? 16 : 17),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (cv != null)
              LinkButton(
                label: 'Download CV',
                url: cv,
                icon: Icons.description_outlined,
                primary: true,
              ),
            LinkButton(
              label: 'Email',
              url: 'mailto:${profile.email}',
              icon: Icons.mail_outline,
              primary: cv == null,
            ),
            LinkButton(label: 'LinkedIn', url: profile.linkedIn),
            LinkButton(label: 'GitHub', url: profile.github),
          ],
        ),
        const SizedBox(height: 32),
        _FactStrip(profile: profile),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.available,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: AppText.label.copyWith(
              color: AppColors.available,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// The 30-second summary: the four facts a recruiter checks first.
class _FactStrip extends StatelessWidget {
  const _FactStrip({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final facts = [
      ('Work rights', profile.workRights, null),
      ('Based in', profile.location, profile.openTo),
      ('Status', profile.status, null),
      ('Core stack', profile.coreStack.join(' · '), null),
    ];

    return Panel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 640
              ? 4
              : constraints.maxWidth >= 380
              ? 2
              : 1;
          const gap = 20.0;
          final cellWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;

          return Wrap(
            spacing: gap,
            runSpacing: 18,
            children: [
              for (final (label, value, note) in facts)
                SizedBox(
                  width: cellWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label.toUpperCase(), style: AppText.label),
                      const SizedBox(height: 6),
                      Text(value, style: AppText.title.copyWith(fontSize: 15)),
                      if (note != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          note,
                          style: AppText.body.copyWith(
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
