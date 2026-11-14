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
    final text = AppText.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(eyebrow: 'Skills', title: 'What I work with'),
        for (final group in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.l),
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
                      style: text.title.copyWith(fontSize: 15),
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

/// The two degrees as equal cards: side by side on wide screens, stacked
/// on phones.
class EducationSection extends StatelessWidget {
  const EducationSection({super.key, required this.education});

  final List<Credential> education;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(eyebrow: 'Education', title: 'Where I studied'),
        LayoutBuilder(
          builder: (context, constraints) => EqualGrid(
            columns: constraints.maxWidth >= 600 ? 2 : 1,
            children: [
              for (final item in education)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: text.title),
                      const SizedBox(height: Space.xs),
                      Text(item.detail, style: text.label),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The published paper, then the university research projects as plain
/// rows, then membership as one small line.
class ResearchSection extends StatelessWidget {
  const ResearchSection({
    super.key,
    required this.research,
    required this.membership,
  });

  final Research research;
  final String membership;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'Research',
          title: 'Papers and university projects',
        ),
        const GroupLabel('Published'),
        for (final paper in research.published) _PublicationRow(paper),
        const SizedBox(height: Space.xxxl),
        const GroupLabel('University research projects'),
        for (final project in research.universityProjects)
          _ResearchRow(
            project,
            tag: research.projectTag,
            pdfOnRequest: research.pdfOnRequest,
          ),
        const SizedBox(height: Space.xxxl),
        Text(membership, style: text.label),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: Space.xl),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.of(context).line)),
    ),
    child: child,
  );
}

class _PublicationRow extends StatelessWidget {
  const _PublicationRow(this.paper);

  final Publication paper;

  @override
  Widget build(BuildContext context) {
    final text = AppText.of(context);
    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Measure(child: Text(paper.title, style: text.title)),
          const SizedBox(height: Space.xs),
          Measure(child: Text(paper.detail, style: text.label)),
          const SizedBox(height: Space.xs),
          Transform.translate(
            offset: const Offset(-Space.s, 0),
            child: InlineLink(label: paper.link.label, url: paper.link.url),
          ),
        ],
      ),
    );
  }
}

class _ResearchRow extends StatefulWidget {
  const _ResearchRow(
    this.project, {
    required this.tag,
    required this.pdfOnRequest,
  });

  final ResearchProject project;
  final String tag;
  final String pdfOnRequest;

  @override
  State<_ResearchRow> createState() => _ResearchRowState();
}

class _ResearchRowState extends State<_ResearchRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final pdf = project.pdfUrl;
    final coAuthors = project.coAuthors;
    final text = AppText.of(context);
    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Measure(child: Text(project.title, style: text.title)),
          const SizedBox(height: Space.s),
          Wrap(
            spacing: Space.m,
            runSpacing: Space.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TagList([widget.tag]),
              Text(project.source, style: text.label),
            ],
          ),
          if (coAuthors != null) ...[
            const SizedBox(height: Space.xs),
            Text('With $coAuthors', style: text.label),
          ],
          const SizedBox(height: Space.s),
          Measure(child: Text(project.summary, style: text.body)),
          const SizedBox(height: Space.xs),
          Transform.translate(
            offset: const Offset(-Space.s, 0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (pdf != null)
                  InlineLink(label: 'PDF', url: pdf)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.s),
                    child: Text(widget.pdfOnRequest, style: text.label),
                  ),
                DisclosureButton(
                  label: 'Abstract',
                  open: _open,
                  onPressed: () => setState(() => _open = !_open),
                ),
              ],
            ),
          ),
          Disclosed(
            open: _open,
            child: Text(project.abstract, style: text.body),
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
    final c = AppColors.of(context);
    final text = AppText.of(context);
    return AppCard(
      color: c.accentSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTACT', style: text.eyebrow),
          const SizedBox(height: Space.s),
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text("Let's talk", style: text.sectionTitle),
          ),
          const SizedBox(height: Space.m),
          Measure(child: Text(profile.closing, style: text.body)),
          const SizedBox(height: Space.xl),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
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
          const SizedBox(height: Space.l),
          Wrap(
            spacing: Space.xs,
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
            color: _copied ? AppColors.of(context).available : null,
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
      builder: (context, followLink) => _IconButton(
        label: label,
        onPressed: followLink,
        icon: BrandIcon(brand, size: 20),
      ),
    );
  }
}

class _IconButton extends StatefulWidget {
  const _IconButton({
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return IconButton(
      tooltip: widget.label,
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => _hovered = value),
      color: _hovered ? c.accent : c.ink,
      iconSize: 20,
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        side: BorderSide(color: c.lineStrong),
        backgroundColor: c.surface,
      ),
      icon: widget.icon,
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
          style: AppText.of(context).label,
        ),
        const InlineLink(
          label: 'Source',
          url: 'https://github.com/hasibullah1811/hasibullah.dev',
        ),
      ],
    );
  }
}
