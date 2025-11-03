import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final arabicHeadlineStyle = GoogleFonts.notoNaskhArabic(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.secondary,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0F14),
            Color(0xFF101A22),
            Color(0xFF1C262E),
            AppColors.surfaceLow,
          ],
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
    return TextField(
      style: AppTextStyles.bodyL.copyWith(color: AppColors.textPrimary),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search for a Surah...',
        hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceHigh.withValues(alpha: 0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textSecondary.withValues(alpha: 0.9)),
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
    final borderRadius = BorderRadius.circular(AppRadius.lg + 4);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x28141F33),
            blurRadius: 32,
            offset: Offset(0, 22),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1C2D44).withValues(alpha: 0.85),
                        const Color(0xFF0F1725).withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: SvgPicture.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.white.withValues(alpha: 0.07),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(color: AppColors.white.withValues(alpha: 0.01)),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.black.withValues(alpha: 0.3),
                        AppColors.black.withValues(alpha: 0.1),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.white.withValues(alpha: 0.04),
                        AppColors.transparent,
                      ],
                      stops: const [0, 0.55],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.04)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Read',
                    style: AppTextStyles.bodyS.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                      style: arabicHeadlineStyle.copyWith(
                        color: const Color(0xFFFFD27D),
                        fontSize: 26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Sura Al-Baqarah',
                          style: AppTextStyles.headingM.copyWith(
                            fontSize: 22,
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Ayah 255',
                          style: AppTextStyles.bodyM.copyWith(
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
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
                          'Continue',
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
                ],
              ),
            ),
          ],
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
    final accentColor = surah.isRead ? AppColors.secondary : AppColors.textSecondary;
    final borderRadius = BorderRadius.circular(AppRadius.md);
    final backgroundGradient = surah.isRead
        ? const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF7A5216),
              Color(0xFF3A2108),
              Color(0xFF0D0602),
            ],
            stops: [0.0, 0.46, 1.0],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2436),
              Color(0xFF0B111D),
            ],
          );
    final shadowColor = surah.isRead ? const Color(0x33FFC857) : const Color(0x20182137);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: surah.isRead ? 24 : 16,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {},
          splashColor: accentColor.withValues(alpha: 0.12),
          highlightColor: accentColor.withValues(alpha: surah.isRead ? 0.18 : 0.08),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: backgroundGradient,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withValues(alpha: surah.isRead ? 0.5 : 0.24),
                          accentColor.withValues(alpha: surah.isRead ? 0.24 : 0.12),
                        ],
                      ),
                      border: Border.all(color: accentColor.withValues(alpha: surah.isRead ? 0.45 : 0.3)),
                          boxShadow: surah.isRead
                              ? [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.18),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      surah.number.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.white,
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
                            color: AppColors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          surah.translation,
                          style: AppTextStyles.bodyS.copyWith(
                            color: AppColors.textSecondary.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Text(
                    surah.arabicName,
                    style: arabicHeadlineStyle.copyWith(
                      color: accentColor.withValues(alpha: surah.isRead ? 0.95 : 0.75),
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
