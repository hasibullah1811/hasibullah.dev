import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/content/portfolio_content.dart';
import 'package:hasib_website/main.dart';

void main() {
  const sizes = {
    'phone': Size(390, 844),
    'tablet': Size(820, 1180),
    'desktop': Size(1440, 900),
  };

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('renders every section without overflow on $name', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const PortfolioApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(portfolio.profile.name), findsOneWidget);
      expect(find.text(portfolio.profile.title), findsWidgets);
      expect(find.text(portfolio.profile.workRights), findsWidgets);
      for (final heading in [
        'From Dhaka to Wollongong',
        'Case studies',
        'What I work with',
        "Let's talk",
      ]) {
        expect(find.text(heading, skipOffstage: false), findsOneWidget);
      }
      for (final study in portfolio.caseStudies) {
        expect(find.text(study.name, skipOffstage: false), findsOneWidget);
      }
    });
  }

  testWidgets('text is selectable and links are focusable buttons', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.byType(SelectionArea), findsOneWidget);
    // Hero contact buttons are real buttons, so Tab reaches them.
    expect(find.widgetWithText(OutlinedButton, 'LinkedIn'), findsWidgets);
    expect(find.widgetWithText(OutlinedButton, 'GitHub'), findsWidgets);
  });

  testWidgets('CV button stays hidden until a CV is configured', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();
    final hasCv = portfolio.profile.cvUrl != null;
    expect(
      find.text('Download CV', skipOffstage: false),
      hasCv ? findsWidgets : findsNothing,
    );
  });
}
