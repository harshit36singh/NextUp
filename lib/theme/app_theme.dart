import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlack = Color(0xFF000000);
  static const Color cardBlack = Color(0xFF0A0A0A);
  static const Color accentGold = Color(0xFFE6B84E);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF888888);
  static const Color borderGray = Color(0xFF1A1A1A);

  static const Color lightBackground = Color(0xFFF5F5F0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightAccent = Color(0xFFD4A574);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightBorder = Color(0xFFE0E0E0);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryBlack,

    colorScheme: const ColorScheme.dark(
      primary: accentGold,
      secondary: accentGold,
      surface: cardBlack,
      background: primaryBlack,
      onPrimary: primaryBlack,
      onSecondary: primaryBlack,
      onSurface: textWhite,
      onBackground: textWhite,
    ),

    cardTheme: CardThemeData(
      color: cardBlack,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: borderGray, width: 1),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textWhite,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 3,
        fontFamily: 'Serif',
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textWhite,
        fontSize: 56,
        fontWeight: FontWeight.w300,
        letterSpacing: -1,
        fontFamily: 'Serif',
      ),
      displayMedium: TextStyle(
        color: textWhite,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        fontFamily: 'Serif',
      ),
      bodyLarge: TextStyle(
        color: textWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: textGray,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: textWhite,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: accentGold,
      labelStyle: const TextStyle(
        color: textWhite,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: borderGray, width: 1),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: borderGray,
      thickness: 1,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,

    colorScheme: const ColorScheme.light(
      primary: lightAccent,
      secondary: lightAccent,
      surface: lightCard,
      background: lightBackground,
      onPrimary: lightBackground,
      onSecondary: lightBackground,
      onSurface: lightTextPrimary,
      onBackground: lightTextPrimary,
    ),

    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: lightBorder, width: 1),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 3,
        fontFamily: 'Serif',
      ),
      iconTheme: IconThemeData(color: lightTextPrimary),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightTextPrimary,
        fontSize: 56,
        fontWeight: FontWeight.w300,
        letterSpacing: -1,
        fontFamily: 'Serif',
      ),
      displayMedium: TextStyle(
        color: lightTextPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        fontFamily: 'Serif',
      ),
      bodyLarge: TextStyle(
        color: lightTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: lightTextSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: lightTextPrimary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: lightAccent,
      labelStyle: const TextStyle(
        color: lightTextPrimary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: lightBorder, width: 1),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: lightBorder,
      thickness: 1,
    ),
  );

  // ── Context-aware helpers ──────────────────────────────────────

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static BoxDecoration cardDecoration(BuildContext context) {
    final isDark = _isDark(context);
    return BoxDecoration(
      color: isDark ? cardBlack : lightCard,
      border: Border.all(
        color: isDark ? borderGray : lightBorder,
        width: 1,
      ),
    );
  }

  static BoxDecoration goldCardDecoration(BuildContext context) {
    final isDark = _isDark(context);
    return BoxDecoration(
      color: isDark ? accentGold : lightAccent,
      border: Border.all(
        color: isDark ? accentGold : lightAccent,
        width: 1,
      ),
    );
  }

  /// Scaffold / page background
  static Color getScaffoldColor(BuildContext context) =>
      _isDark(context) ? primaryBlack : lightBackground;

  /// Primary accent (gold / warm gold)
  static Color getPrimaryColor(BuildContext context) =>
      _isDark(context) ? accentGold : lightAccent;

  /// Page background (alias for getScaffoldColor, kept for compatibility)
  static Color getBackgroundColor(BuildContext context) =>
      _isDark(context) ? primaryBlack : lightBackground;

  /// Card surface
  static Color getCardColor(BuildContext context) =>
      _isDark(context) ? cardBlack : lightCard;

  /// Primary text
  static Color getTextColor(BuildContext context) =>
      _isDark(context) ? textWhite : lightTextPrimary;

  /// Secondary / muted text
  static Color getSecondaryTextColor(BuildContext context) =>
      _isDark(context) ? textGray : lightTextSecondary;

  /// Border color
  static Color getBorderColor(BuildContext context) =>
      _isDark(context) ? borderGray : lightBorder;
}