import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Design tokens — warm paper palette
// ─────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const bg = Color(0xFFF4F1EC);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1816);
  static const ink2 = Color(0xFF4A453E);
  static const ink3 = Color(0xFF8A847A);
  static const ink4 = Color(0xFFC4BDB1);
  static const line = Color(0x141A1816); // ~8% opacity
  static const lineStrong = Color(0x241A1816); // ~14% opacity
}

// ─────────────────────────────────────────────────────────────
// Counter tint palette
// ─────────────────────────────────────────────────────────────
class CounterTint {
  const CounterTint({
    required this.name,
    required this.bg,
    required this.ink,
    required this.dot,
  });

  final String name;
  final Color bg;
  final Color ink;
  final Color dot;
}

const counterTints = <String, CounterTint>{
  'sand': CounterTint(
    name: 'Sand',
    bg: Color(0xFFEDE4D3),
    ink: Color(0xFF5A4A2B),
    dot: Color(0xFFB89862),
  ),
  'sage': CounterTint(
    name: 'Sage',
    bg: Color(0xFFDEE7DA),
    ink: Color(0xFF3B5238),
    dot: Color(0xFF7B9B74),
  ),
  'rose': CounterTint(
    name: 'Rose',
    bg: Color(0xFFEFDDD8),
    ink: Color(0xFF6B3A34),
    dot: Color(0xFFBE7466),
  ),
  'sky': CounterTint(
    name: 'Sky',
    bg: Color(0xFFD9E3ED),
    ink: Color(0xFF2E4A66),
    dot: Color(0xFF7196B8),
  ),
  'plum': CounterTint(
    name: 'Plum',
    bg: Color(0xFFE3DAE6),
    ink: Color(0xFF4B3558),
    dot: Color(0xFF8E7AA0),
  ),
  'clay': CounterTint(
    name: 'Clay',
    bg: Color(0xFFE7D9CE),
    ink: Color(0xFF62402A),
    dot: Color(0xFFB08265),
  ),
  'stone': CounterTint(
    name: 'Stone',
    bg: Color(0xFFE3E1DC),
    ink: Color(0xFF3B3934),
    dot: Color(0xFF8F8A7F),
  ),
};

const defaultTintKey = 'stone';

/// Looks up a tint by the stored backgroundColor int value.
/// Falls back to [defaultTintKey] if no match is found.
CounterTint tintFromBackgroundColor(int? bgColor) {
  if (bgColor == null) return counterTints[defaultTintKey]!;
  for (final entry in counterTints.entries) {
    if (entry.value.dot.toARGB32() == bgColor) {
      return entry.value;
    }
  }
  return counterTints[defaultTintKey]!;
}

/// Returns the tint key for a given backgroundColor int.
String tintKeyFromBackgroundColor(int? bgColor) {
  if (bgColor == null) return defaultTintKey;
  for (final entry in counterTints.entries) {
    if (entry.value.dot.toARGB32() == bgColor) {
      return entry.key;
    }
  }
  return defaultTintKey;
}

// ─────────────────────────────────────────────────────────────
// Theme builder
// ─────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.light(
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      primary: AppColors.ink,
      onPrimary: AppColors.bg,
      error: const Color(0xFF6B3A34),
      outline: AppColors.ink4,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.ink,
      foregroundColor: AppColors.bg,
      elevation: 8,
      shape: CircleBorder(),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line),
      ),
      margin: EdgeInsets.zero,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: AppColors.ink,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'SF Mono',
        fontSize: 72,
        fontWeight: FontWeight.w400,
        letterSpacing: -3,
        color: AppColors.ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'SF Mono',
        fontSize: 28,
        fontWeight: FontWeight.w500,
        letterSpacing: -1,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontFamily: '.SF Pro Display',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.ink2,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.ink3,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: AppColors.ink3,
      ),
    ),
  );
}
