import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Roboto', // Example font
      textTheme: const TextTheme(
        headline1: AppTextStyles.headline1,
        headline2: AppTextStyles.headline2,
        bodyText1: AppTextStyles.bodyText1,
        bodyText2: AppTextStyles.bodyText2,
        caption: AppTextStyles.caption,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.black,
      fontFamily: 'Roboto', // Example font
      textTheme: const TextTheme(
        headline1: AppTextStyles.headline1,
        headline2: AppTextStyles.headline2,
        bodyText1: AppTextStyles.bodyText1,
        bodyText2: AppTextStyles.bodyText2,
        caption: AppTextStyles.caption,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
    );
  }
}
