import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/content/portfolio_content.dart';
import 'package:hasib_website/main.dart';

/// The journey background drifts forever while visible, so tests pump for a
/// fixed time instead of waiting to settle.
Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  bool reducedMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  if (reducedMotion) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }
  await tester.pumpWidget(const PortfolioApp());
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
    testWidgets('renders every section without overflow on $name', (
      tester,
    ) async {
      await _pumpApp(tester, size: size);

      expect(tester.takeException(), isNull);
      expect(find.text(portfolio.profile.name), findsOneWidget);
      expect(find.text(portfolio.profile.title), findsWidgets);
      expect(find.text(portfolio.profile.workRights), findsWidgets);
      for (final heading in [
        journey.title,
        'Case studies',
        'What I work with',
        "Let's talk",
        for (final c in journey.chapters) c.name,
      ]) {
        expect(find.text(heading, skipOffstage: false), findsOneWidget);
      }
      expect(find.text(journey.move, skipOffstage: false), findsOneWidget);
      expect(find.text(span.title, skipOffstage: false), findsOneWidget);
      for (final study in portfolio.caseStudies) {
        expect(find.text(study.name, skipOffstage: false), findsOneWidget);
      }
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
    for (final value in ['2,000', '5', '180', '~20']) {
      expect(find.text(value, skipOffstage: false), findsWidgets);
    }
    // Every journey card fully visible.
    final opacities = tester
        .widgetList<Opacity>(find.byType(Opacity, skipOffstage: false))
        .map((o) => o.opacity);
    expect(opacities, everyElement(1.0));
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
}
