import 'package:flutter/material.dart';

import '../content/models.dart';
import '../theme.dart';
import 'sections/details.dart';
import 'sections/hero.dart';
import 'sections/journey.dart';
import 'sections/work.dart';
import 'widgets/common.dart';

const contentMaxWidth = 760.0;

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, required this.content});

  final PortfolioContent content;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _journeyKey = GlobalKey();
  final _workKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  void _jumpTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final compact = isCompact(context);
    final gutter = compact ? 20.0 : 32.0;
    final gap = SizedBox(height: compact ? 72 : 96);

    // The scroll view spans the full window so the wheel works anywhere and
    // the scrollbar sits at the window edge; only the content is constrained.
    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  gutter,
                  compact ? 20 : 32,
                  gutter,
                  48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopNav(
                      onJourney: () => _jumpTo(_journeyKey),
                      onWork: () => _jumpTo(_workKey),
                      onSkills: () => _jumpTo(_skillsKey),
                      onContact: () => _jumpTo(_contactKey),
                    ),
                    SizedBox(height: compact ? 40 : 64),
                    HeroSection(profile: content.profile),
                    gap,
                    KeyedSubtree(
                      key: _journeyKey,
                      child: JourneySection(stops: content.journey),
                    ),
                    gap,
                    KeyedSubtree(
                      key: _workKey,
                      child: WorkSection(
                        caseStudies: content.caseStudies,
                        projects: content.projects,
                      ),
                    ),
                    gap,
                    KeyedSubtree(
                      key: _skillsKey,
                      child: SkillsSection(groups: content.skills),
                    ),
                    gap,
                    CredentialsSection(credentials: content.credentials),
                    gap,
                    KeyedSubtree(
                      key: _contactKey,
                      child: ContactSection(profile: content.profile),
                    ),
                    const SizedBox(height: 40),
                    SiteFooter(profile: content.profile),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.onJourney,
    required this.onWork,
    required this.onSkills,
    required this.onContact,
  });

  final VoidCallback onJourney;
  final VoidCallback onWork;
  final VoidCallback onSkills;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final navStyle = TextButton.styleFrom(
      foregroundColor: AppColors.inkSoft,
      textStyle: const TextStyle(
        fontFamily: AppFonts.sans,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Page sections',
      child: Wrap(
        spacing: 2,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              'hasibullah.dev',
              style: AppText.label.copyWith(color: AppColors.ink),
            ),
          ),
          TextButton(
            style: navStyle,
            onPressed: onJourney,
            child: const Text('Journey'),
          ),
          TextButton(
            style: navStyle,
            onPressed: onWork,
            child: const Text('Work'),
          ),
          TextButton(
            style: navStyle,
            onPressed: onSkills,
            child: const Text('Skills'),
          ),
          TextButton(
            style: navStyle,
            onPressed: onContact,
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }
}
