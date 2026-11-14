import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../widgets/common.dart';

/// StepWise as the one featured block, then every other project as a
/// compact row separated by hairlines. No cards, no per-row motion.
class WorkSection extends StatelessWidget {
  const WorkSection({
    super.key,
    required this.featured,
    required this.projects,
  });

  final CaseStudy featured;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(eyebrow: 'Work', title: 'Projects'),
        _Featured(featured),
        const SizedBox(height: Space.xxxl),
        const GroupLabel('More projects'),
        for (final project in projects) _ProjectRow(project),
      ],
    );
  }
}

class _Featured extends StatelessWidget {
  const _Featured(this.study);

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final image = study.image;
    final c = AppColors.of(context);
    final text = AppText.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Space.m,
          runSpacing: Space.s,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.s,
                vertical: Space.xs,
              ),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(Radii.small),
              ),
              child: Text(
                study.status,
                style: text.label.copyWith(color: c.accent),
              ),
            ),
            Text(study.period, style: text.label),
          ],
        ),
        const SizedBox(height: Space.m),
        Semantics(
          header: true,
          headingLevel: 3,
          child: Text(study.name, style: text.cardTitle),
        ),
        const SizedBox(height: Space.xs),
        Measure(
          child: Text(study.tagline, style: text.body.copyWith(color: c.ink)),
        ),
        if (image != null) ...[
          const SizedBox(height: Space.xl),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: c.line),
              borderRadius: BorderRadius.circular(Radii.card),
            ),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 1600 / 696,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                semanticLabel: study.imageAlt,
              ),
            ),
          ),
        ],
        const SizedBox(height: Space.xl),
        _Fact(label: 'Problem', text: study.problem),
        _Fact(label: 'What I built', text: study.built),
        _Fact(label: 'Outcome', text: study.outcome),
        const SizedBox(height: Space.s),
        TagList(study.stack),
        if (study.links.isNotEmpty) ...[
          const SizedBox(height: Space.s),
          _Links(study.links),
        ],
      ],
    );
  }
}

/// A label beside one line of text on wide screens, above it on phones.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    final style = AppText.of(context);
    final body = Measure(child: Text(text, style: style.body));
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.l),
      child: Flex(
        direction: compact ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: compact ? null : 120,
            child: Padding(
              padding: EdgeInsets.only(
                top: compact ? 0 : 3,
                bottom: compact ? Space.xs : 0,
              ),
              child: Text(label.toUpperCase(), style: style.label),
            ),
          ),
          if (compact) body else Expanded(child: body),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatefulWidget {
  const _ProjectRow(this.project);

  final Project project;

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final c = AppColors.of(context);
    final text = AppText.of(context);
    final meta = [project.period, ?project.status].join(' · ');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Space.xl),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Space.m,
            runSpacing: Space.xs,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Semantics(
                header: true,
                headingLevel: 3,
                child: Text(project.name, style: text.title),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(meta, style: text.label),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Measure(child: Text(project.description, style: text.body)),
          if (project.bullets.isNotEmpty) ...[
            const SizedBox(height: Space.s),
            Measure(child: BulletList(project.bullets)),
          ],
          const SizedBox(height: Space.m),
          TagList(project.stack),
          if (project.links.isNotEmpty || project.details.isNotEmpty) ...[
            const SizedBox(height: Space.xs),
            Transform.translate(
              // Text buttons carry their own padding; align their text with
              // the column edge.
              offset: const Offset(-Space.s, 0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final link in project.links)
                    InlineLink(label: link.label, url: link.url),
                  if (project.details.isNotEmpty)
                    DisclosureButton(
                      label: 'Details',
                      open: _open,
                      onPressed: () => setState(() => _open = !_open),
                    ),
                ],
              ),
            ),
          ],
          if (project.details.isNotEmpty)
            Disclosed(
              open: _open,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, line) in project.details.indexed) ...[
                    if (i > 0) const SizedBox(height: Space.s),
                    Text(line, style: text.body),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Links extends StatelessWidget {
  const _Links(this.links);

  final List<LinkItem> links;

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: const Offset(-Space.s, 0),
    child: Wrap(
      children: [
        for (final link in links) InlineLink(label: link.label, url: link.url),
      ],
    ),
  );
}
