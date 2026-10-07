import 'dart:async';

import 'package:flutter/material.dart';

import '../platform/browser.dart' as browser;

/// Light or dark, following the system until the visitor picks one. The pick
/// is remembered in localStorage (the same key web/index.html reads before
/// Flutter starts, so the loader never flashes the wrong theme).
class ThemeController extends ChangeNotifier {
  ThemeController({String? stored})
    : _mode = switch (stored) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };

  /// Reads the stored choice from the browser.
  factory ThemeController.fromBrowser() =>
      ThemeController(stored: browser.readStoredTheme());

  /// MaterialApp's own theme animation. Zero, because the sunset reveal
  /// covers the switch; [crossfade] sets it briefly for the fallback.
  static const crossfadeDuration = Duration(milliseconds: 250);

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  Duration _themeAnimation = Duration.zero;
  Duration get themeAnimation => _themeAnimation;
  Timer? _resetAnimation;

  /// Switches to [brightness] and remembers it. With [crossfade] the colours
  /// blend over [crossfadeDuration] instead of switching at once.
  void choose(Brightness brightness, {bool crossfade = false}) {
    final dark = brightness == Brightness.dark;
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    browser.storeTheme(dark ? 'dark' : 'light');
    _resetAnimation?.cancel();
    _themeAnimation = crossfade ? crossfadeDuration : Duration.zero;
    if (crossfade) {
      // Back to instant, so a later system change doesn't animate.
      _resetAnimation = Timer(crossfadeDuration * 2, () {
        _themeAnimation = Duration.zero;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _resetAnimation?.cancel();
    super.dispose();
  }
}
