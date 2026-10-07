import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/main.dart';
import 'package:hasib_website/theme.dart';
import 'package:hasib_website/ui/theme_controller.dart';
import 'package:hasib_website/ui/widgets/page_background.dart';
import 'package:hasib_website/ui/widgets/theme_toggle.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

Future<ThemeController> _pumpApp(
  WidgetTester tester, {
  String? theme,
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
  final controller = ThemeController(stored: theme);
  addTearDown(controller.dispose);
  await tester.pumpWidget(PortfolioApp(themeController: controller));
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  return controller;
}

final _revealOverlay = find.byWidgetPredicate(
  (w) => w is CustomPaint && '${w.painter.runtimeType}' == '_RevealPainter',
);

/// The toggle's icon, found by its semantic label.
Finder _toggle(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

Brightness _brightness(WidgetTester tester) =>
    Theme.of(tester.element(find.text('hasibullah.dev'))).brightness;

void main() {
  for (final colors in [AppColors.light, AppColors.dark]) {
    final name = colors.brightness.name;

    test('every $name text colour meets WCAG AA on every background', () {
      // The strongest background symbol, at its peak, on the centre of the
      // cursor glow.
      final glow = Color.alphaBlend(colors.symbolGlowColor, colors.paper);
      final backgrounds = {
        'paper': colors.paper,
        'surface': colors.surface,
        'tint': colors.tint,
        'accentSoft': colors.accentSoft,
        'paper + dot': Color.alphaBlend(
          colors.ink.withValues(alpha: PageBackground.dotAlpha),
          colors.paper,
        ),
        'paper + glow + symbol': Color.alphaBlend(
          colors.symbolColor.withValues(alpha: colors.symbolPeakOpacity),
          glow,
        ),
        'paper + glow + ink symbol': Color.alphaBlend(
          colors.ink.withValues(alpha: colors.symbolInkPeakOpacity),
          glow,
        ),
      };
      final texts = {
        'ink': colors.ink,
        'inkSoft': colors.inkSoft,
        'muted': colors.muted,
        'accent': colors.accent,
        'available': colors.available,
      };
      for (final MapEntry(key: t, value: fg) in texts.entries) {
        for (final MapEntry(key: b, value: bg) in backgrounds.entries) {
          expect(
            _contrast(fg, bg),
            greaterThanOrEqualTo(4.5),
            reason: '$name $t on $b',
          );
        }
      }
      // Filled buttons and tooltips: paper on ink.
      expect(_contrast(colors.paper, colors.ink), greaterThanOrEqualTo(4.5));
    });
  }

  test('background symbols stay subtle, the glow faint', () {
    for (final colors in [AppColors.light, AppColors.dark]) {
      final name = colors.brightness.name;
      expect(colors.symbolPeakOpacity, lessThanOrEqualTo(0.4), reason: name);
      expect(colors.symbolInkPeakOpacity, lessThanOrEqualTo(0.4), reason: name);
      expect(colors.symbolGlowColor.a, lessThanOrEqualTo(0.08), reason: name);
      // The colour is opaque; its strength comes from the peak opacity.
      expect(colors.symbolColor.a, 1.0, reason: name);
    }
    expect(PageBackground.dotAlpha, lessThanOrEqualTo(0.08));
    expect(PageBackground.reducedScatterScale, lessThan(1));
    expect(PageBackground.scatterScale, lessThan(1));
  });

  testWidgets('pointer symbols fade out and the ticker stops', (tester) async {
    await _pumpApp(tester, theme: 'light');
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: const Offset(100, 300));
    for (var i = 1; i <= 12; i++) {
      await mouse.moveTo(Offset(100 + i * 90.0, 300));
      await tester.pump(const Duration(milliseconds: 160));
    }
    // The symbol ticker, plus whatever else is animating on the page.
    final running = tester.binding.transientCallbackCount;
    // Rise 120ms, hold 150ms, fade 900ms. The background keeps time with a
    // real stopwatch, so let real time pass.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 1250)),
    );
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.binding.transientCallbackCount, running - 1);
    expect(tester.takeException(), isNull);
  });

  test('the loader in index.html uses the same palette', () {
    final html = File('web/index.html').readAsStringSync().toUpperCase();
    for (final colors in [AppColors.light, AppColors.dark]) {
      for (final c in [
        colors.paper,
        colors.ink,
        colors.inkSoft,
        colors.muted,
        colors.accent,
        colors.available,
      ]) {
        expect(html, contains(_hex(c)), reason: colors.brightness.name);
      }
    }
    // Same storage key as lib/platform/browser_web.dart.
    expect(html, contains("LOCALSTORAGE.GETITEM('THEME')"));
    expect(html, contains('PREFERS-COLOR-SCHEME: DARK'));
  });

  testWidgets('follows the system theme until the visitor picks one', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await _pumpApp(tester);
    expect(_brightness(tester), Brightness.dark);
    // No transition on load.
    expect(_revealOverlay, findsNothing);
  });

  testWidgets('a stored choice wins over the system theme', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await _pumpApp(tester, theme: 'light');
    expect(_brightness(tester), Brightness.light);
  });

  testWidgets('the toggle is labelled and switches theme with the reveal', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = await _pumpApp(tester, theme: 'light');

    expect(find.bySemanticsLabel('Switch to dark mode'), findsOneWidget);
    final toggleState = tester.state(find.byType(ThemeToggle));
    await tester.tap(find.bySemanticsLabel('Switch to dark mode'));
    await tester.pump();
    // The same toggle animates its sunset; it isn't rebuilt in the new state.
    expect(tester.state(find.byType(ThemeToggle)), same(toggleState));
    expect(controller.mode, ThemeMode.dark);
    expect(_brightness(tester), Brightness.dark);

    // Mid-transition: the old screenshot is on top, and a second tap is
    // ignored.
    await tester.pump(const Duration(milliseconds: 300));
    expect(_revealOverlay, findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel('Switch to light mode'),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(controller.mode, ThemeMode.dark);

    // The reveal starts a frame after the switch and runs 800ms.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.bySemanticsLabel('Switch to light mode'), findsOneWidget);
    expect(_revealOverlay, findsNothing);
    expect(tester.takeException(), isNull);

    // And back again.
    await tester.tap(find.bySemanticsLabel('Switch to light mode'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(_brightness(tester), Brightness.light);
    semantics.dispose();
  });

  testWidgets('reduced motion switches with a short crossfade', (tester) async {
    final controller = await _pumpApp(
      tester,
      theme: 'light',
      reducedMotion: true,
    );
    await tester.tap(_toggle('Switch to dark mode'));
    await tester.pump();
    expect(controller.themeAnimation, ThemeController.crossfadeDuration);
    await tester.pump(const Duration(seconds: 1));
    expect(_brightness(tester), Brightness.dark);
    expect(controller.themeAnimation, Duration.zero);
  });

  testWidgets('the toggle works from the keyboard', (tester) async {
    final controller = await _pumpApp(tester, theme: 'dark');
    final icon = _toggle('Switch to light mode');
    Focus.of(tester.element(icon)).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(controller.mode, ThemeMode.light);
  });
}
