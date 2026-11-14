import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/content/portfolio_content.dart';
import 'package:hasib_website/main.dart';
import 'package:hasib_website/ui/theme_controller.dart';
import 'package:hasib_website/ui/widgets/common.dart';

/// The journey background drifts forever while visible, so tests pump for a
/// fixed time instead of waiting to settle.
Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  bool reducedMotion = false,
  String? theme,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  if (reducedMotion) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }
  await tester.pumpWidget(
    PortfolioApp(themeController: ThemeController(stored: theme)),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  final journey = portfolio.journey;
  final span = journey.chapters.first.span!;
  const sizes = {
    'phone': Size(390, 844),
    'tablet': Size(820, 1180),
    'desktop': Size(1440, 900),
  };

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    for (final theme in ['light', 'dark']) {
      testWidgets('renders every section without overflow on $name ($theme)', (
        tester,
      ) async {
        await _pumpApp(tester, size: size, theme: theme);
        expect(tester.takeException(), isNull);
        expect(
          Theme.of(tester.element(find.text('hasibullah.dev'))).brightness.name,
          theme,
        );
      });
    }

    testWidgets('stat cards share one size and the column edge on $name', (
      tester,
    ) async {
      await _pumpApp(tester, size: size);
      final cards = [
        for (final m in portfolio.about.metrics)
          tester.getRect(
            find
                .ancestor(
                  of: find.text(m.label, skipOffstage: false),
                  matching: find.byType(AppCard),
                )
                .first,
          ),
      ];
      final header = tester.getRect(
        find.text(portfolio.about.title, skipOffstage: false),
      );
      for (final card in cards) {
        expect(card.width, moreOrLessEquals(cards.first.width, epsilon: 0.01));
        expect(
          card.height,
          moreOrLessEquals(cards.first.height, epsilon: 0.01),
        );
      }
      expect(cards.first.left, moreOrLessEquals(header.left, epsilon: 0.01));
      final perRow = cards.where((c) => c.top == cards.first.top).length;
      expect(perRow, size.width < 600 ? 2 : 4);
      // Every label on one line.
      for (final m in portfolio.about.metrics) {
        final label = tester.getRect(find.text(m.label, skipOffstage: false));
        expect(label.height, lessThan(20), reason: m.label);
      }
    });

    testWidgets('education: two equal cards on $name', (tester) async {
      await _pumpApp(tester, size: size);
      final rects = [
        for (final c in portfolio.education)
          tester.getRect(
            find
                .ancestor(
                  of: find.text(c.title, skipOffstage: false),
                  matching: find.byType(AppCard),
                )
                .first,
          ),
      ];
      expect(rects, hasLength(2));
      expect(
        rects.last.width,
        moreOrLessEquals(rects.first.width, epsilon: 0.01),
      );
      if (size.width >= 600) {
        expect(rects.last.top, rects.first.top);
        expect(
          rects.last.height,
          moreOrLessEquals(rects.first.height, epsilon: 0.01),
        );
      } else {
        expect(rects.last.top, greaterThan(rects.first.bottom));
      }
    });

    testWidgets('body text stays within the reading width on $name', (
      tester,
    ) async {
      await _pumpApp(tester, size: size);
      for (final p in portfolio.research.universityProjects) {
        final rect = tester.getRect(find.text(p.summary, skipOffstage: false));
        expect(rect.width, lessThanOrEqualTo(bodyMaxWidth), reason: p.slug);
      }
    });

    testWidgets('renders every section without overflow on $name', (
      tester,
    ) async {
      await _pumpApp(tester, size: size);

      expect(tester.takeException(), isNull);
      final profile = portfolio.profile;
      expect(find.text(profile.name), findsOneWidget);
      expect(find.text(profile.tagline), findsOneWidget);
      expect(
        find.textContaining(profile.workRightsShort),
        findsWidgets,
        reason: 'availability line',
      );
      expect(find.textContaining(profile.location), findsWidgets);
      for (final heading in [
        portfolio.about.title,
        journey.title,
        'Projects',
        'What I work with',
        'Where I studied',
        'Papers and university projects',
        "Let's talk",
        for (final c in journey.chapters) c.name,
      ]) {
        expect(find.text(heading, skipOffstage: false), findsOneWidget);
      }
      expect(find.text(journey.move, skipOffstage: false), findsOneWidget);
      expect(find.text(span.title, skipOffstage: false), findsOneWidget);
      for (final name in [
        portfolio.featured.name,
        ...portfolio.projects.map((p) => p.name),
      ]) {
        expect(find.text(name, skipOffstage: false), findsOneWidget);
      }
      expect(
        find.text(portfolio.membership, skipOffstage: false),
        findsOneWidget,
      );
    });
  }

  testWidgets('part-time work is a side bar on wide screens only', (
    tester,
  ) async {
    final label = span.label.toUpperCase();
    await _pumpApp(tester, size: const Size(1440, 900));
    expect(find.text(label, skipOffstage: false), findsOneWidget);

    await _pumpApp(tester, size: const Size(390, 844));
    expect(find.text(label, skipOffstage: false), findsNothing);
    expect(find.text(span.title, skipOffstage: false), findsOneWidget);
  });

  testWidgets('reduced motion shows the finished journey immediately', (
    tester,
  ) async {
    await _pumpApp(tester, reducedMotion: true);

    // Final numbers, no count-up.
    for (final value in ['2,000', '5', '180', '~20', '500–700']) {
      expect(find.text(value, skipOffstage: false), findsWidgets);
    }
    // Every journey card and revealed section fully visible.
    final opacities = tester
        .widgetList<Opacity>(find.byType(Opacity, skipOffstage: false))
        .map((o) => o.opacity);
    expect(opacities, everyElement(1.0));
    final fades = tester
        .widgetList<FadeTransition>(
          find.byType(FadeTransition, skipOffstage: false),
        )
        .map((f) => f.opacity.value);
    expect(fades, everyElement(1.0));
  });

  testWidgets('LeetCode is linked in the hero and contact section', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.widgetWithText(OutlinedButton, 'LeetCode'), findsOneWidget);
    expect(
      find.byTooltip('LeetCode', skipOffstage: false),
      findsOneWidget,
      reason: 'contact icon link',
    );
  });

  testWidgets('the core stack strip is gone', (tester) async {
    await _pumpApp(tester);
    expect(find.text('CORE STACK', skipOffstage: false), findsNothing);
  });

  testWidgets('text is selectable and links are focusable buttons', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.byType(SelectionArea), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'LinkedIn'), findsWidgets);
    expect(find.widgetWithText(OutlinedButton, 'GitHub'), findsWidgets);
  });

  testWidgets('CV button stays hidden until a CV is configured', (
    tester,
  ) async {
    await _pumpApp(tester);
    final hasCv = portfolio.profile.cvUrl != null;
    expect(
      find.text('Download CV', skipOffstage: false),
      hasCv ? findsWidgets : findsNothing,
    );
  });

  testWidgets('research rows: tag, co-authors, PDF on request, closed '
      'abstract', (tester) async {
    await _pumpApp(tester);
    final research = portfolio.research;
    final projects = research.universityProjects;
    expect(
      find.text(research.projectTag, skipOffstage: false),
      findsNWidgets(projects.length),
    );
    expect(
      find.text(research.pdfOnRequest, skipOffstage: false),
      findsNWidgets(projects.where((p) => p.pdfUrl == null).length),
    );
    for (final p in projects) {
      if (p.coAuthors case final names?) {
        expect(find.text('With $names', skipOffstage: false), findsWidgets);
      }
      expect(find.text(p.abstract, skipOffstage: false), findsNothing);
    }
    expect(
      find.text(
        '${research.published.single.link.label} ↗',
        skipOffstage: false,
      ),
      findsWidgets,
    );

    final first = find.text('Abstract', skipOffstage: false).first;
    await tester.ensureVisible(first);
    await tester.tap(first);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(projects.first.abstract), findsOneWidget);
  });

  testWidgets('project details start closed and open on tap', (tester) async {
    await _pumpApp(tester);
    final minima = portfolio.projects.firstWhere((p) => p.name == 'Minima');
    expect(find.text(minima.details.first, skipOffstage: false), findsNothing);
    final toggle = find.text('Details', skipOffstage: false).first;
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(minima.details.first), findsOneWidget);
    expect(find.text('Architecture ↗', skipOffstage: false), findsNWidgets(2));
  });
}
