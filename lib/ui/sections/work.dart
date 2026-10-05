import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
import '../motion.dart';
import '../widgets/common.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({
    super.key,
    required this.caseStudies,
    required this.projects,
  });

  final List<CaseStudy> caseStudies;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(eyebrow: 'Work', title: 'Case studies'),
        for (final study in caseStudies) ...[
          // The featured card runs its own reveal (with a drawn rule).
          study.featured
              ? _CaseStudyCard(study)
              : ScrollReveal(child: _CaseStudyCard(study)),
          const SizedBox(height: 20),
        ],
        const SizedBox(height: 28),
        ScrollReveal(
          child: Text('Earlier and smaller projects', style: AppText.cardTitle),
        ),
        const SizedBox(height: 16),
        _ProjectGrid(projects),
      ],
    );
  }
}

class _CaseStudyCard extends StatelessWidget {
  const _CaseStudyCard(this.study);

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    final status = study.status;
    final image = study.image;
    final diagram = study.diagram;
    final featured = study.featured;
    final compact = isCompact(context);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (featured)
              Text('FEATURED', style: AppText.eyebrow.copyWith(fontSize: 11)),
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: AppText.label.copyWith(color: AppColors.accent),
                ),
              ),
            Text(study.period, style: AppText.label),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          headingLevel: 3,
          child: Text(
            study.name,
            style: featured
                ? AppText.sectionTitle.copyWith(fontSize: compact ? 28 : 32)
                : AppText.cardTitle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          study.tagline,
          style: AppText.lead.copyWith(fontSize: featured ? 18 : 17),
        ),
        if (image != null) ...[
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8),
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
        if (diagram != null) ...[
          const SizedBox(height: 20),
          _Diagram(url: diagram, alt: study.diagramAlt),
        ],
        const SizedBox(height: 20),
        _Part(
          label: 'Problem',
          child: Text(study.problem, style: AppText.body),
        ),
        _Part(label: 'What I did', child: BulletList(study.work)),
        _Part(
          label: 'Outcome',
          child: Text(study.outcome, style: AppText.body),
        ),
        TagList(study.stack),
        if (study.links.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            children: [
              for (final link in study.links)
                InlineLink(label: link.label, url: link.url),
            ],
          ),
        ],
      ],
    );

    final padding = EdgeInsets.all(compact ? 18 : (featured ? 28 : 24));
    if (!featured) return LiftCard(padding: padding, child: body);

    // The lead card: an accent rule draws across the top as it arrives.
    return ScrollReveal(
      duration: Motion.draw + Motion.reveal,
      builder: (context, reveal) => LiftCard(
        padding: EdgeInsets.zero,
        borderColor: AppColors.lineStrong,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              child: DrawLine(progress: reveal, thickness: 3, start: 0.3),
            ),
            Padding(padding: padding, child: body),
          ],
        ),
      ),
    );
  }
}

/// An architecture diagram in a fixed window. It loads only once scrolled
/// near, fades in, and on hover pans slowly to show the rest of the image.
/// The "Architecture" link still opens it full size.
class _Diagram extends StatefulWidget {
  const _Diagram({required this.url, this.alt});

  final String url;
  final String? alt;

  @override
  State<_Diagram> createState() => _DiagramState();
}

class _DiagramState extends State<_Diagram> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ScrollReveal(
            builder: (context, reveal) => reveal.isDismissed && !reduced
                // Not near the viewport yet: reserve the space, skip the
                // download.
                ? const SizedBox.expand()
                : TweenAnimationBuilder<Alignment>(
                    tween: AlignmentTween(
                      end: _hovered && !reduced
                          ? Alignment.bottomCenter
                          : Alignment.topCenter,
                    ),
                    duration: const Duration(milliseconds: 2400),
                    curve: Curves.easeInOutCubic,
                    builder: (context, alignment, _) => Image.network(
                      widget.url,
                      fit: BoxFit.fitWidth,
                      alignment: alignment,
                      semanticLabel: widget.alt,
                      filterQuality: FilterQuality.medium,
                      // Fades in once decoded instead of popping in.
                      frameBuilder: (context, child, frame, sync) =>
                          sync || reduced
                          ? child
                          : AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: Motion.reveal,
                              curve: Motion.curve,
                              child: child,
                            ),
                      errorBuilder: (context, error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.alt ?? 'Architecture diagram',
                            style: AppText.label,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Part extends StatelessWidget {
  const _Part({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppText.label),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid(this.projects);

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final project in projects) ...[
          ScrollReveal(child: _ProjectCard(project)),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return LiftCard(
      padding: EdgeInsets.all(isCompact(context) ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.period, style: AppText.label),
          const SizedBox(height: 6),
          Semantics(
            header: true,
            headingLevel: 3,
            child: Text(
              project.name,
              style: AppText.title.copyWith(fontSize: 17),
            ),
          ),
          const SizedBox(height: 6),
          Text(project.description, style: AppText.body),
          const SizedBox(height: 12),
          TagList(project.stack),
          const SizedBox(height: 4),
          Wrap(
            children: [
              for (final link in project.links)
                InlineLink(label: link.label, url: link.url),
            ],
          ),
        ],
      ),
    );
  }
}
