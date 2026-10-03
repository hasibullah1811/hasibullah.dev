import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../widgets/common.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.groups});

  final List<SkillGroup> groups;

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(eyebrow: 'Skills', title: 'What I work with'),
        for (final group in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Flex(
              direction: compact ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: compact ? null : 180,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: compact ? 0 : 5,
                      bottom: compact ? 8 : 0,
                    ),
                    child: Text(
                      group.name,
                      style: AppText.title.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                if (compact)
                  TagList(group.items)
                else
                  Expanded(child: TagList(group.items)),
              ],
            ),
          ),
      ],
    );
  }
}

class CredentialsSection extends StatelessWidget {
  const CredentialsSection({super.key, required this.credentials});

  final List<Credential> credentials;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'Credentials',
          title: 'Education, research and membership',
        ),
        for (final item in credentials)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.kind.toUpperCase(), style: AppText.label),
                const SizedBox(height: 6),
                Text(item.title, style: AppText.title),
                const SizedBox(height: 2),
                Text(item.detail, style: AppText.body),
                if (item.link case final link?)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Transform.translate(
                      offset: const Offset(-8, 0),
                      child: InlineLink(label: link.label, url: link.url),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final cv = profile.cvUrl;
    return Panel(
      color: AppColors.accentSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTACT', style: AppText.eyebrow),
          const SizedBox(height: 8),
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text("Let's talk", style: AppText.sectionTitle),
          ),
          const SizedBox(height: 10),
          Text(
            "I'm looking for a full-time ${profile.title} role. I'm based in "
            '${profile.location}, open to relocation and remote, and have '
            '${profile.workRights[0].toLowerCase()}'
            '${profile.workRights.substring(1)}.',
            style: AppText.body.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              LinkButton(
                label: 'Email me',
                url: 'mailto:${profile.email}',
                icon: Icons.mail_outline,
                primary: true,
              ),
              if (cv != null)
                LinkButton(
                  label: 'Download CV',
                  url: cv,
                  icon: Icons.description_outlined,
                ),
              LinkButton(label: 'LinkedIn', url: profile.linkedIn),
              LinkButton(label: 'GitHub', url: profile.github),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Text(
                profile.email,
                style: AppText.label.copyWith(
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
              IconButton(
                tooltip: 'Copy email address',
                icon: const Icon(Icons.copy_rounded, size: 18),
                color: AppColors.inkSoft,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: profile.email));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email address copied')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '© ${DateTime.now().year} ${profile.name} · Built with Flutter ·',
          style: AppText.label,
        ),
        const InlineLink(
          label: 'Source',
          url: 'https://github.com/hasibullah1811/hasibullah.dev',
        ),
      ],
    );
  }
}
