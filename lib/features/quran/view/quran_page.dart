import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  static const _surahs = [
    _QuranSurah(
      number: 1,
      englishName: 'Al-Fatiha',
      translation: 'The Opening',
      arabicName: 'ٱلْفَاتِحَة',
      isRead: true,
    ),
    _QuranSurah(
      number: 2,
      englishName: 'Al-Baqarah',
      translation: 'The Cow',
      arabicName: 'ٱلْبَقَرَة',
      isRead: true,
    ),
    _QuranSurah(
      number: 3,
      englishName: 'Aal-E-Imran',
      translation: 'The Family of Imran',
      arabicName: 'آلِ عِمْرَان',
      isRead: true,
    ),
    _QuranSurah(
      number: 4,
      englishName: 'An-Nisa',
      translation: 'The Women',
      arabicName: 'ٱلنِّسَاء',
      isRead: false,
    ),
    _QuranSurah(
      number: 5,
      englishName: 'Al-Ma\'idah',
      translation: 'The Table Spread',
      arabicName: 'ٱلْمَائِدَة',
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const arabicHeadlineStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.secondary,
      height: 1.2,
      fontFamilyFallback: ['Noto Naskh Arabic', 'Geeza Pro', 'Arial'],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.getBackgroundGradient(context),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.xxl + AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SurahSearchField(),
                const SizedBox(height: AppSpacing.lg),
                _LastReadCard(arabicHeadlineStyle: arabicHeadlineStyle),
                const SizedBox(height: AppSpacing.xl),
                ...List.generate(
                  _surahs.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _surahs.length - 1 ? 0 : AppSpacing.md,
                    ),
                    child: _SurahCard(
                      surah: _surahs[index],
                      arabicHeadlineStyle: arabicHeadlineStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahSearchField extends StatelessWidget {
  const _SurahSearchField();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      style: AppTextStyles.bodyL.copyWith(
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
      ),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search for a Surah...',
        hintStyle: AppTextStyles.bodyM.copyWith(
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceHigh.withValues(alpha: 0.8)
            : AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark
              ? AppColors.textSecondary.withValues(alpha: 0.9)
              : AppColors.lightTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}

class _LastReadCard extends StatelessWidget {
  final TextStyle arabicHeadlineStyle;

  const _LastReadCard({required this.arabicHeadlineStyle});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A2436),
                    Color(0xFF0B111D),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lightSurface.withValues(alpha: 0.95),
                    AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
                  ],
                ),
          border: Border.all(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.08)
                : AppColors.lightTextMuted.withValues(alpha: 0.2),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -8),
                          child: Text(
                            'Son Okunan',
                            style: AppTextStyles.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                              letterSpacing: 0.6,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow effect
                                Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF62F5FF).withValues(alpha: 0.2),
                                        blurRadius: 50,
                                        spreadRadius: 10,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF4D8DFF).withValues(alpha: 0.175),
                                        blurRadius: 65,
                                        spreadRadius: 8,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF87CEEB).withValues(alpha: 0.15),
                                        blurRadius: 70,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // SVG
                                SvgPicture.asset(
                                  'assets/images/Quran.svg',
                                  width: 200,
                                  height: 200,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -100),
                          child: Center(
                            child: Text(
                              'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                              style: arabicHeadlineStyle.copyWith(
                                color: const Color(0xFFFFD27D),
                                fontSize: 26,
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -85),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bakara Suresi',
                            style: AppTextStyles.headingM.copyWith(
                              fontSize: 22,
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Ayet 255',
                            style: AppTextStyles.bodyM.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4D8DFF),
                      Color(0xFF62F5FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF62F5FF).withValues(alpha: 0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md + 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Devam Et',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                    SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final _QuranSurah surah;
  final TextStyle arabicHeadlineStyle;

  const _SurahCard({
    required this.surah,
    required this.arabicHeadlineStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.textSecondary : AppColors.lightTextMuted;
    final borderRadius = BorderRadius.circular(36);
    final backgroundGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2436),
              Color(0xFF0B111D),
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightSurface.withValues(alpha: 0.95),
              AppColors.lightSurfaceHigh.withValues(alpha: 0.9),
            ],
          );
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {},
          splashColor: accentColor.withValues(alpha: 0.12),
          highlightColor: accentColor.withValues(alpha: 0.08),
          child: Opacity(
            opacity: surah.isRead ? 0.6 : 1.0,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: backgroundGradient,
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.08)
                      : AppColors.lightTextMuted.withValues(alpha: 0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.024),
                            accentColor.withValues(alpha: 0.012),
                          ],
                        ),
                        border: Border.all(color: accentColor.withValues(alpha: 0.03)),
                      ),
                      child: Text(
                        surah.number.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            surah.englishName,
                            style: AppTextStyles.headingM.copyWith(
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            surah.translation,
                            style: AppTextStyles.bodyS.copyWith(
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.9)
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Text(
                      surah.arabicName,
                      style: arabicHeadlineStyle.copyWith(
                        color: surah.isRead
                            ? (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)
                            : const Color(0xFFFFD27D),
                        fontSize: surah.isRead ? 24 : 22,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuranSurah {
  final int number;
  final String englishName;
  final String translation;
  final String arabicName;
  final bool isRead;

  const _QuranSurah({
    required this.number,
    required this.englishName,
    required this.translation,
    required this.arabicName,
    required this.isRead,
  });
}
