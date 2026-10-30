import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors matching reference design
  static const Color primaryLime = Color(0xFFC6F52B);
  static const Color primaryLimeDark = Color(0xFFAEDC1C);
  static const Color darkNavy = Color(0xFF0F172A);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color starGold = Color(0xFFF59E0B);
  static const Color discountRed = Color(0xFFEF4444);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Currency
  static const String currencySymbol = '₹';

  // Soft Shadows
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // Application Theme Data
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLime,
        primary: primaryLime,
        secondary: darkNavy,
        surface: cardBg,
      ),
      fontFamily: 'Roboto', // Clean default sans-serif
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
