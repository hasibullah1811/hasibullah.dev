import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../motion.dart';
import '../widgets/brand_icons.dart';
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
          ScrollReveal(
            child: Padding(
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
          ),
      ],
    );
  }
}

/// Education, the publication and membership as small cards, each with an
/// accent rule that draws in as it arrives.
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
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 560 ? 2 : 1;
            const gap = 12.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final (i, item) in credentials.indexed)
                  SizedBox(
                    width: width,
                    child: ScrollReveal(
                      duration: Motion.draw + Motion.reveal,
                      delay: Duration(milliseconds: 80 * (i % columns)),
                      builder: (context, reveal) =>
                          _CredentialCard(item, reveal: reveal),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CredentialCard extends StatelessWidget {
  const _CredentialCard(this.item, {required this.reveal});

  final Credential item;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    return LiftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.kind.toUpperCase(), style: AppText.eyebrow),
          const SizedBox(height: 6),
          DrawLine(progress: reveal, width: 32, start: 0.3),
          const SizedBox(height: 12),
          Text(item.title, style: AppText.title),
          const SizedBox(height: 4),
          Text(item.detail, style: AppText.body.copyWith(fontSize: 14)),
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
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final cv = profile.cvUrl;
    return ScrollReveal(
      duration: Motion.draw + Motion.reveal,
      builder: (context, reveal) => Panel(
        color: AppColors.accentSoft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('CONTACT', style: AppText.eyebrow),
                  const SizedBox(height: 6),
                  DrawLine(progress: reveal, start: 0.3),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Semantics(
              header: true,
              headingLevel: 2,
              child: Text("Let's talk", style: AppText.sectionTitle),
            ),
            const SizedBox(height: 10),
            Text(profile.closing, style: AppText.body.copyWith(fontSize: 16)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LinkButton(
                  label: 'Email me',
                  url: 'mailto:${profile.email}',
                  icon: const Icon(Icons.mail_outline, size: 18),
                  primary: true,
                ),
                _CopyEmail(profile.email),
                if (cv != null)
                  LinkButton(
                    label: 'Download CV',
                    url: cv,
                    icon: const Icon(Icons.description_outlined, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              children: [
                _IconLink(
                  label: 'LinkedIn',
                  url: profile.linkedIn,
                  brand: Brand.linkedIn,
                ),
                _IconLink(
                  label: 'GitHub',
                  url: profile.github,
                  brand: Brand.gitHub,
                ),
                _IconLink(
                  label: 'LeetCode',
                  url: profile.leetCode,
                  brand: Brand.leetCode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the address and copies it. The icon turns into a check for two
/// seconds, and screen readers hear "Copied".
class _CopyEmail extends StatefulWidget {
  const _CopyEmail(this.email);

  final String email;

  @override
  State<_CopyEmail> createState() => _CopyEmailState();
}

class _CopyEmailState extends State<_CopyEmail> {
  bool _copied = false;
  Timer? _reset;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.email));
    if (!mounted) return;
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = Motion.reduced(context) ? Duration.zero : Motion.hover;
    return Tooltip(
      message: 'Copy email address',
      child: OutlinedButton.icon(
        onPressed: _copy,
        icon: AnimatedSwitcher(
          duration: duration,
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Motion.curve,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Icon(
            _copied ? Icons.check_rounded : Icons.copy_rounded,
            key: ValueKey(_copied),
            size: 18,
            color: _copied ? AppColors.available : null,
          ),
        ),
        label: Semantics(
          liveRegion: true,
          child: Text(
            _copied ? 'Copied' : widget.email,
            style: _copied
                ? null
                : const TextStyle(fontFamily: AppFonts.mono, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _IconLink extends StatelessWidget {
  const _IconLink({
    required this.label,
    required this.url,
    required this.brand,
  });

  final String label;
  final String url;
  final Brand brand;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: LinkTarget.blank,
      builder: (context, followLink) => _LiftIconButton(
        label: label,
        onPressed: followLink,
        icon: BrandIcon(brand, size: 20),
      ),
    );
  }
}

class _LiftIconButton extends StatefulWidget {
  const _LiftIconButton({
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  State<_LiftIconButton> createState() => _LiftIconButtonState();
}

class _LiftIconButtonState extends State<_LiftIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, _hovered ? -0.06 : 0),
      duration: Motion.reduced(context) ? Duration.zero : Motion.hover,
      curve: Motion.curve,
      child: IconButton(
        tooltip: widget.label,
        onPressed: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        color: _hovered ? AppColors.accent : AppColors.ink,
        iconSize: 20,
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          side: const BorderSide(color: AppColors.lineStrong),
          backgroundColor: AppColors.surface,
        ),
        icon: widget.icon,
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
