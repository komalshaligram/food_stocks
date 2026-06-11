import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ערכת עיצוב Material 3 עם Heebo (או גופן מערכת כשאין רשת), RTL ועיצוב כרטיסים.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: null,
      textTheme: _textTheme,
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surface,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextTheme get _textTheme {
    const fallback = TextStyle(fontFamily: null);
    final base = TextTheme(
      titleLarge: fallback.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: fallback.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: fallback.copyWith(fontSize: 16),
      bodyMedium: fallback.copyWith(fontSize: 14),
      bodySmall: fallback.copyWith(fontSize: 12),
      labelLarge: fallback.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
    );
    return base;
  }
}
