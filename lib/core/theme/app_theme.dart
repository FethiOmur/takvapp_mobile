import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
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
    );
  }
}
