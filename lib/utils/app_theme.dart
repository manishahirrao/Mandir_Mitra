import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color sacredBlue = Color(0xFF004C99);
  static const Color goldenAccent = Color(0xFFD4AF37);
  static const Color divineGold = Color(0xFFD4AF37);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningAmber = Color(0xFFF57C00);
  static const Color templeBrown = Color(0xFF5D4037);
  static const Color templeCream = Color(0xFFFAF9F6);
  static const Color sacredWhite = Color(0xFFFFFFFF);
  static const Color earthTones = Color(0xFF6B5A3E);
  static const Color gangajalBlue = Color(0xFF00A3E0);
  static const Color sacredGrey = Color(0xFF333333);
  static const Color saffronYellow = Color(0xFFFF9933);
  
  // Gradients
  static const LinearGradient sacredGradient = LinearGradient(
    colors: [sacredBlue, Color(0xFF0066CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient peacefulGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  
  // Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusFull = 999.0;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: sacredBlue,
      primary: sacredBlue,
      secondary: goldenAccent,
      error: errorRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: sacredBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sacredBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: sacredBlue,
      brightness: Brightness.dark,
      primary: sacredBlue,
      secondary: goldenAccent,
      error: errorRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sacredBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
