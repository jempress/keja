import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E3A5F); // deep indigo-blue, brand/CTA
  static const accent = Color(0xFFD9720F); // warm amber, "featured" badges
  static const success = Color(0xFF2E7D32); // verified-agent stamp
  static const danger = Color(0xFFC62828); // saved/heart, destructive
  static const surface = Color(0xFFFAF8F3); // warm off-white background
  static const surfaceAlt = Color(0xFFF1EDE3);
  static const border = Color(0xFFE4DFD3);
  static const textPrimary = Color(0xFF1C1B19);
  static const textSecondary = Color(0xFF6B6660);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Colors.white,
        side: BorderSide(color: AppColors.border),
        labelStyle: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        shape: StadiumBorder(),
      ),
    );
  }
}
