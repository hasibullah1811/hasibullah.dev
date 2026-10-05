import 'package:flutter/material.dart';

// White page, dark ink, one terracotta accent.
// Every text colour here is at least 4.5:1 on paper, surface, tint and
// accentSoft, and on the brightest background dot (see DotBackground).
class AppColors {
  static const paper = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);

  /// Tags and other quiet fills on white.
  static const tint = Color(0xFFF6F4F1);
  static const ink = Color(0xFF1B1916);
  static const inkSoft = Color(0xFF45413A);
  static const muted = Color(0xFF615B52);
  static const line = Color(0xFFE8E6E1);
  static const lineStrong = Color(0xFFD6D2CA);
  static const accent = Color(0xFFA63F25);
  static const accentSoft = Color(0xFFFBEFEA);
  static const available = Color(0xFF277046);
}

class AppFonts {
  static const serif = 'SourceSerif4';
  static const sans = 'Geist';
  static const mono = 'GeistMono';
}

class AppText {
  static const display = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w600,
    fontSize: 46,
    height: 1.1,
    letterSpacing: -0.5,
    color: AppColors.ink,
  );

  static const sectionTitle = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.2,
    color: AppColors.ink,
  );

  static const cardTitle = TextStyle(
    fontFamily: AppFonts.serif,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.25,
    color: AppColors.ink,
  );

  static const lead = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 19,
    height: 1.5,
    color: AppColors.inkSoft,
  );

  static const title = TextStyle(
    fontFamily: AppFonts.sans,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.4,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    height: 1.6,
    color: AppColors.inkSoft,
  );

  static const label = TextStyle(
    fontFamily: AppFonts.mono,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.4,
    letterSpacing: 0.4,
    color: AppColors.muted,
  );

  static const eyebrow = TextStyle(
    fontFamily: AppFonts.mono,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.4,
    letterSpacing: 1.2,
    color: AppColors.accent,
  );
}

ThemeData buildTheme() {
  final focusRing = WidgetStateProperty.resolveWith<BorderSide?>(
    (states) => states.contains(WidgetState.focused)
        ? const BorderSide(color: AppColors.accent, width: 2)
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
    brightness: Brightness.light,
    fontFamily: AppFonts.sans,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      surface: AppColors.paper,
      primary: AppColors.ink,
      onPrimary: AppColors.paper,
      secondary: AppColors.accent,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color(0x33A63F25),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.paper,
        padding: buttonPadding,
        textStyle: buttonText,
        shape: buttonShape,
      ).copyWith(side: focusRing),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            foregroundColor: AppColors.ink,
            backgroundColor: AppColors.surface,
            padding: buttonPadding,
            textStyle: buttonText,
            shape: buttonShape,
          ).copyWith(
            side: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? const BorderSide(color: AppColors.accent, width: 2)
                  : const BorderSide(color: AppColors.line),
            ),
          ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(0, 36),
        textStyle: buttonText.copyWith(fontSize: 13),
        shape: buttonShape,
      ).copyWith(side: focusRing),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(
        fontFamily: AppFonts.sans,
        color: AppColors.paper,
      ),
    ),
  );
}
