import 'package:flutter/material.dart';

import '../content/models.dart';
import '../theme.dart';
import 'sections/about.dart';
import 'sections/details.dart';
import 'sections/hero.dart';
import 'sections/journey.dart';
import 'sections/work.dart';
import 'widgets/common.dart';
import 'widgets/page_background.dart';

const contentMaxWidth = 760.0;

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key, required this.content});

  final PortfolioContent content;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _aboutKey = GlobalKey();
  final _journeyKey = GlobalKey();
  final _workKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

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
      body: PageBackground(
        textColumnWidth: contentMaxWidth,
        child: Stack(
          children: [
            SelectionArea(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: contentMaxWidth,
                    ),
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
                            onAbout: () => _jumpTo(_aboutKey),
                            onJourney: () => _jumpTo(_journeyKey),
                            onWork: () => _jumpTo(_workKey),
                            onSkills: () => _jumpTo(_skillsKey),
                            onContact: () => _jumpTo(_contactKey),
                          ),
                          SizedBox(height: compact ? 40 : 64),
                          HeroSection(profile: content.profile),
                          gap,
                          KeyedSubtree(
                            key: _aboutKey,
                            child: AboutSection(about: content.about),
                          ),
                          gap,
                          KeyedSubtree(
                            key: _journeyKey,
                            child: JourneySection(journey: content.journey),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 2,
              child: _ScrollProgress(_scroll),
            ),
          ],
        ),
      ),
    );
  }
}

/// A thin accent line across the top that grows with the scroll position.
/// Driven by the controller, so scrolling repaints only this line.
class _ScrollProgress extends StatelessWidget {
  const _ScrollProgress(this.controller);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _ProgressPainter(controller, AppColors.of(context).accent),
          ),
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter(this.controller, this.color) : super(repaint: controller);

  final ScrollController controller;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (!controller.hasClients) return;
    final position = controller.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }
    final progress = (position.pixels / position.maxScrollExtent).clamp(
      0.0,
      1.0,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter old) =>
      old.controller != controller || old.color != color;
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.onAbout,
    required this.onJourney,
    required this.onWork,
    required this.onSkills,
    required this.onContact,
  });

  final VoidCallback onAbout;
  final VoidCallback onJourney;
  final VoidCallback onWork;
  final VoidCallback onSkills;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final navStyle = TextButton.styleFrom(
      foregroundColor: c.inkSoft,
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
              style: AppText.of(context).label.copyWith(color: c.ink),
            ),
          ),
          for (final (label, onPressed) in [
            ('About', onAbout),
            ('Journey', onJourney),
            ('Work', onWork),
            ('Skills', onSkills),
            ('Contact', onContact),
          ])
            UnderlineButton(
              label: label,
              onPressed: onPressed,
              style: navStyle,
            ),
        ],
      ),
    );
  }
}
