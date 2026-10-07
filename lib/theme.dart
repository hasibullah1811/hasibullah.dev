import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

// Background code symbols (lib/ui/widgets/page_background.dart).
//
// To make the symbols stronger or weaker, change the *SymbolPeak values: the
// opacity each symbol reaches at its brightest. *GlowPeak is the soft halo
// under the cursor. These sit at the AA limit: raising any of them makes
// test/theme_test.dart fail if a text colour would drop below 4.5:1 where it
// overlaps a symbol. Touch and reduced motion use a fixed fraction of the
// peak (PageBackground.scatterScale and reducedScatterScale).
const lightSymbolPeak = 0.14; // terracotta symbols
const lightInkSymbolPeak = 0.10; // the 1 in 4 drawn in ink
const lightGlowPeak = 0.05;
const darkSymbolPeak = 0.21; // lightened terracotta symbols
const darkInkSymbolPeak = 0.0; // dark mode has no ink symbols
const darkGlowPeak = 0.05;

/// Every colour the site uses, as a theme extension so widgets read them from
/// the ambient theme: `AppColors.of(context)`.
///
/// Light: white page, dark ink, one terracotta accent.
/// Dark: warm near-black page, off-white ink, a lightened terracotta, and
/// card borders instead of shadows.
///
/// In both themes every text colour (ink, inkSoft, muted, accent, available)
/// is at least 5.1:1 on paper, surface, tint and accentSoft, and at least
/// 4.5:1 on paper under the strongest background symbol sitting on the
/// cursor glow. The values are listed in docs/theme.md;
/// test/theme_test.dart checks them.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.paper,
    required this.surface,
    required this.tint,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.line,
    required this.lineStrong,
    required this.accent,
    required this.accentSoft,
    required this.available,
    required this.hoverShadow,
    required this.symbolColor,
    required this.symbolPeakOpacity,
    required this.symbolInkPeakOpacity,
    required this.symbolGlowColor,
  });

  static const light = AppColors(
    brightness: Brightness.light,
    paper: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    tint: Color(0xFFF6F4F1),
    ink: Color(0xFF1B1916),
    inkSoft: Color(0xFF45413A),
    muted: Color(0xFF615B52),
    line: Color(0xFFE8E6E1),
    lineStrong: Color(0xFFD6D2CA),
    accent: Color(0xFFA63F25),
    accentSoft: Color(0xFFFBEFEA),
    available: Color(0xFF277046),
    hoverShadow: Color(0x121B1916),
    symbolColor: Color(0xFFA63F25),
    symbolPeakOpacity: lightSymbolPeak,
    symbolInkPeakOpacity: lightInkSymbolPeak,
    symbolGlowColor: Color.fromRGBO(166, 63, 37, lightGlowPeak),
  );

  static const dark = AppColors(
    brightness: Brightness.dark,
    paper: Color(0xFF171412),
    surface: Color(0xFF201C19),
    tint: Color(0xFF2A2521),
    ink: Color(0xFFF3EEE7),
    inkSoft: Color(0xFFD3CBC0),
    muted: Color(0xFFABA296),
    line: Color(0xFF332D29),
    lineStrong: Color(0xFF4A423B),
    accent: Color(0xFFE8957A),
    accentSoft: Color(0xFF38251E),
    available: Color(0xFF7CC79A),
    // Dark cards lift with a stronger border only.
    hoverShadow: Color(0x00000000),
    symbolColor: Color(0xFFE8957A),
    symbolPeakOpacity: darkSymbolPeak,
    symbolInkPeakOpacity: darkInkSymbolPeak,
    symbolGlowColor: Color.fromRGBO(232, 149, 122, darkGlowPeak),
  );

  final Brightness brightness;

  /// The page.
  final Color paper;

  /// Cards and panels.
  final Color surface;

  /// Tags and other quiet fills.
  final Color tint;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color line;
  final Color lineStrong;
  final Color accent;
  final Color accentSoft;
  final Color available;

  /// Shadow under a hovered card; transparent in dark mode.
  final Color hoverShadow;

  /// Background code symbols, opaque; painted at up to [symbolPeakOpacity].
  final Color symbolColor;
  final double symbolPeakOpacity;

  /// Peak opacity of the symbols drawn in [ink] instead; 0 for none.
  final double symbolInkPeakOpacity;

  /// Centre of the halo under the cursor, alpha included.
  final Color symbolGlowColor;

  bool get isDark => brightness == Brightness.dark;

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      paper: mix(paper, other.paper),
      surface: mix(surface, other.surface),
      tint: mix(tint, other.tint),
      ink: mix(ink, other.ink),
      inkSoft: mix(inkSoft, other.inkSoft),
      muted: mix(muted, other.muted),
      line: mix(line, other.line),
      lineStrong: mix(lineStrong, other.lineStrong),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      available: mix(available, other.available),
      hoverShadow: mix(hoverShadow, other.hoverShadow),
      symbolColor: mix(symbolColor, other.symbolColor),
      symbolPeakOpacity: lerpDouble(
        symbolPeakOpacity,
        other.symbolPeakOpacity,
        t,
      )!,
      symbolInkPeakOpacity: lerpDouble(
        symbolInkPeakOpacity,
        other.symbolInkPeakOpacity,
        t,
      )!,
      symbolGlowColor: mix(symbolGlowColor, other.symbolGlowColor),
    );
  }
}

class AppFonts {
  static const serif = 'SourceSerif4';
  static const sans = 'Geist';
  static const mono = 'GeistMono';
}

/// The type scale, coloured for one [AppColors]. Built once per palette:
/// `AppText.of(context)`.
class AppText {
  AppText._(AppColors c)
    : display = TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w600,
        fontSize: 46,
        height: 1.1,
        letterSpacing: -0.5,
        color: c.ink,
      ),
      sectionTitle = TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        height: 1.2,
        color: c.ink,
      ),
      cardTitle = TextStyle(
        fontFamily: AppFonts.serif,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        height: 1.25,
        color: c.ink,
      ),
      lead = TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 19,
        height: 1.5,
        color: c.inkSoft,
      ),
      title = TextStyle(
        fontFamily: AppFonts.sans,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.4,
        color: c.ink,
      ),
      body = TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 15,
        height: 1.6,
        color: c.inkSoft,
      ),
      label = TextStyle(
        fontFamily: AppFonts.mono,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.4,
        letterSpacing: 0.4,
        color: c.muted,
      ),
      eyebrow = TextStyle(
        fontFamily: AppFonts.mono,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.4,
        letterSpacing: 1.2,
        color: c.accent,
      );

  final TextStyle display;
  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle lead;
  final TextStyle title;
  final TextStyle body;
  final TextStyle label;
  final TextStyle eyebrow;

  static final _cache = Expando<AppText>();

  static AppText of(BuildContext context) => forColors(AppColors.of(context));

  static AppText forColors(AppColors colors) =>
      _cache[colors] ??= AppText._(colors);
}

ThemeData buildTheme(AppColors c) {
  final focusRing = WidgetStateProperty.resolveWith<BorderSide?>(
    (states) => states.contains(WidgetState.focused)
        ? BorderSide(color: c.accent, width: 2)
        : null,
  );
  const buttonPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 14);
  const buttonText = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: c.brightness,
    fontFamily: AppFonts.sans,
    scaffoldBackgroundColor: c.paper,
    canvasColor: c.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.accent,
      brightness: c.brightness,
      surface: c.paper,
      onSurface: c.ink,
      primary: c.ink,
      onPrimary: c.paper,
      secondary: c.accent,
    ),
    extensions: [c],
    // Buttons are flat, so this only stops each button animating its colours
    // (under the reveal's screenshot) when the theme switches.
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(animationDuration: Duration.zero),
    ),
    iconTheme: IconThemeData(color: c.ink),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: c.accent.withValues(alpha: 0.2),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 12,
        color: c.paper,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.ink,
        foregroundColor: c.paper,
        padding: buttonPadding,
        textStyle: buttonText,
        shape: buttonShape,
        animationDuration: Duration.zero,
      ).copyWith(side: focusRing),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            foregroundColor: c.ink,
            backgroundColor: c.surface,
            padding: buttonPadding,
            textStyle: buttonText,
            shape: buttonShape,
            animationDuration: Duration.zero,
          ).copyWith(
            side: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? BorderSide(color: c.accent, width: 2)
                  : BorderSide(color: c.isDark ? c.lineStrong : c.line),
            ),
          ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.accent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(0, 36),
        textStyle: buttonText.copyWith(fontSize: 13),
        shape: buttonShape,
        animationDuration: Duration.zero,
      ).copyWith(side: focusRing),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.ink,
      contentTextStyle: TextStyle(fontFamily: AppFonts.sans, color: c.paper),
    ),
  );
}
