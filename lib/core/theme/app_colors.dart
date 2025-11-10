import 'package:flutter/material.dart';

class AppColors {
  // Brand palette
  static const Color primary = Color(0xFF4D8DFF);
  static const Color primaryVariant = Color(0xFF2F6BEB);
  static const Color secondary = Color(0xFFFFC857);
  static const Color secondaryVariant = Color(0xFFF6A63B);

  // Neutral surface stack
  static const Color background = Color(0xFF050A1A);
  static const Color surface = Color(0xFF0D182F);
  static const Color surfaceHigh = Color(0xFF152542);
  static const Color surfaceLow = Color(0xFF0A1426);

  // Content colors
  static const Color textPrimary = Color(0xFFE6EDF7);
  static const Color textSecondary = Color(0xFF9AA7C5);
  static const Color textMuted = Color(0xFF6E7C9E);
  static const Color success = Color(0xFF4CC38A);
  static const Color error = Color(0xFFFF6B6B);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFE8ECF1);
  static const Color lightSurfaceLow = Color(0xFFF0F2F5);
  static const Color lightTextPrimary = Color(0xFF1A1F2E);
  static const Color lightTextSecondary = Color(0xFF6E7C9E);
  static const Color lightTextMuted = Color(0xFF9AA7C5);

  // Gradient colors for backgrounds
  static List<Color> getBackgroundGradient(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      return [
        const Color(0xFFF5F7FA),
        const Color(0xFFE8ECF1),
        const Color(0xFFF0F2F5),
        const Color(0xFFFFFFFF),
      ];
    } else {
      return [
        const Color(0xFF0A0F14),
        const Color(0xFF101A22),
        const Color(0xFF1C262E),
        surfaceLow,
      ];
    }
  }

  // Darker gradient for profile page (50% darker)
  static List<Color> getProfileBackgroundGradient(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      return [
        const Color(0xFFD0D5DB), // %50 daha koyu light theme
        const Color(0xFFC4CCD8),
        const Color(0xFFD8DEE5),
        const Color(0xFFE0E5EA),
      ];
    } else {
      return [
        const Color(0xFF05070A), // %50 daha koyu: 0xFF0A0F14 -> 0xFF05070A
        const Color(0xFF080D11), // %50 daha koyu: 0xFF101A22 -> 0xFF080D11
        const Color(0xFF0E1317), // %50 daha koyu: 0xFF1C262E -> 0xFF0E1317
        const Color(0xFF0A0F14), // surfaceLow'un daha koyu versiyonu
      ];
    }
  }
}
