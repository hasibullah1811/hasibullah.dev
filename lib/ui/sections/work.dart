import 'package:flutter/material.dart';

import '../../content/models.dart';
import '../../theme.dart';
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
          _CaseStudyCard(study),
          const SizedBox(height: 20),
        ],
        const SizedBox(height: 28),
        Text('Earlier and smaller projects', style: AppText.cardTitle),
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

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
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
            child: Text(study.name, style: AppText.cardTitle),
          ),
          const SizedBox(height: 4),
          Text(study.tagline, style: AppText.lead.copyWith(fontSize: 17)),
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
          _ProjectCard(project),
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
    return Panel(
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
