import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFE8ECF1);
  static const Color lightSurfaceLow = Color(0xFFF0F2F5);
  static const Color lightTextPrimary = Color(0xFF1A1F2E);
  static const Color lightTextSecondary = Color(0xFF6E7C9E);
  static const Color lightTextMuted = Color(0xFF9AA7C5);

  static ThemeData get darkTheme {
    final base = ThemeData(brightness: Brightness.dark);

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      displayLarge: AppTextStyles.displayXL,
      displayMedium: AppTextStyles.displayL,
      titleMedium: AppTextStyles.headingM,
      bodyLarge: AppTextStyles.bodyL,
      bodyMedium: AppTextStyles.bodyM,
      bodySmall: AppTextStyles.bodyS,
      labelLarge: AppTextStyles.label,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      canvasColor: AppColors.surfaceLow,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: AppTextStyles.bodyM,
        ),
      ),
      dividerColor: AppColors.surfaceHigh
          .withAlpha((0.35 * 255).round()),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(brightness: Brightness.light);

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      displayLarge: AppTextStyles.displayXL.copyWith(color: lightTextPrimary),
      displayMedium: AppTextStyles.displayL.copyWith(color: lightTextPrimary),
      titleMedium: AppTextStyles.headingM.copyWith(color: lightTextPrimary),
      bodyLarge: AppTextStyles.bodyL.copyWith(color: lightTextPrimary),
      bodyMedium: AppTextStyles.bodyM.copyWith(color: lightTextSecondary),
      bodySmall: AppTextStyles.bodyS.copyWith(color: lightTextMuted),
      labelLarge: AppTextStyles.label.copyWith(color: lightTextSecondary),
    );

    return base.copyWith(
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightSurface,
      canvasColor: lightSurfaceLow,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: lightSurface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: lightTextPrimary,
        onSurface: lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: lightTextPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: AppTextStyles.bodyM,
        ),
      ),
      dividerColor: lightSurfaceHigh.withAlpha((0.5 * 255).round()),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: lightTextMuted,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
