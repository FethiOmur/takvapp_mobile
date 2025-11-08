import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';

class HomeInsightsRow extends StatelessWidget {
  const HomeInsightsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        final isLoading = state is PrayerTimesLoading || state is PrayerTimesInitial;
        final prayerTimes = state is PrayerTimesSuccess ? state.prayerTimes : null;

        final cards = [
          _PrayerCardData(
            label: 'Sabah',
            value: prayerTimes?.fajr ?? '--:--',
            icon: Icons.nightlight_round,
          ),
          _PrayerCardData(
            label: 'Güneş',
            value: prayerTimes?.sunrise ?? '--:--',
            icon: Icons.wb_sunny,
          ),
          _PrayerCardData(
            label: 'Öğle',
            value: prayerTimes?.dhuhr ?? '--:--',
            icon: Icons.wb_sunny,
          ),
          _PrayerCardData(
            label: 'İkindi',
            value: prayerTimes?.asr ?? '--:--',
            icon: Icons.wb_sunny_outlined,
          ),
          _PrayerCardData(
            label: 'Akşam',
            value: prayerTimes?.maghrib ?? '--:--',
            icon: Icons.bedtime,
          ),
          _PrayerCardData(
            label: 'Yatsı',
            value: prayerTimes?.isha ?? '--:--',
            icon: Icons.dark_mode_outlined,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - (AppSpacing.md * 2)) / 3;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: cards.map((card) {
                return SizedBox(
                  width: cardWidth,
                  child: _InsightCard(
                    label: card.label,
                    value: card.value,
                    icon: card.icon,
                    loading: isLoading,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class _PrayerCardData {
  final String label;
  final String value;
  final IconData icon;

  _PrayerCardData({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool loading;

  const _InsightCard({
    required this.label,
    required this.value,
    required this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
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
                        AppColors.surfaceHigh.withValues(alpha: 0.6),
                        AppColors.surface.withValues(alpha: 0.5),
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: -4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(height: AppSpacing.sm),
                  Text(label, style: AppTextStyles.bodyS.copyWith(color: AppColors.white)),
                  const SizedBox(height: AppSpacing.xs),
                  loading
                      ? const SizedBox(
                          height: 12,
                          width: 48,
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.surfaceLow,
                            valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        )
                      : Text(value, style: AppTextStyles.displayL.copyWith(color: AppColors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
