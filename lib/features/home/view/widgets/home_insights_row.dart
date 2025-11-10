import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';

class HomeInsightsRow extends StatelessWidget {
  const HomeInsightsRow({super.key});

  String? _getNextPrayerTime(PrayerTimes? prayerTimes) {
    if (prayerTimes == null) return null;

    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    // Parse prayer times
    final times = [
      _parseTime(prayerTimes.fajr, 'Sabah'),
      _parseTime(prayerTimes.sunrise, 'Güneş'),
      _parseTime(prayerTimes.dhuhr, 'Öğle'),
      _parseTime(prayerTimes.asr, 'İkindi'),
      _parseTime(prayerTimes.maghrib, 'Akşam'),
      _parseTime(prayerTimes.isha, 'Yatsı'),
    ].where((t) => t != null).cast<Map<String, dynamic>>().toList();

    // Find next prayer time
    for (final time in times) {
      final prayerTime = time['time'] as TimeOfDay;
      if (prayerTime.hour > currentTime.hour ||
          (prayerTime.hour == currentTime.hour && prayerTime.minute > currentTime.minute)) {
        return time['label'] as String;
      }
    }

    // If no prayer time found for today, return first one (next day)
    return times.isNotEmpty ? times[0]['label'] as String : null;
  }

  Map<String, dynamic>? _parseTime(String? timeStr, String label) {
    if (timeStr == null || timeStr == '--:--') return null;
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return {
        'time': TimeOfDay(hour: hour, minute: minute),
        'label': label,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        final isLoading = state is PrayerTimesLoading || state is PrayerTimesInitial;
        final prayerTimes = state is PrayerTimesSuccess ? state.prayerTimes : null;
        final nextPrayerLabel = _getNextPrayerTime(prayerTimes);

        final cards = [
          _PrayerCardData(
            label: 'Sabah',
            value: prayerTimes?.fajr ?? '--:--',
            icon: Icons.nightlight_round,
            isNext: nextPrayerLabel == 'Sabah',
          ),
          _PrayerCardData(
            label: 'Güneş',
            value: prayerTimes?.sunrise ?? '--:--',
            icon: Icons.wb_sunny,
            isNext: nextPrayerLabel == 'Güneş',
          ),
          _PrayerCardData(
            label: 'Öğle',
            value: prayerTimes?.dhuhr ?? '--:--',
            icon: Icons.wb_sunny,
            isNext: nextPrayerLabel == 'Öğle',
          ),
          _PrayerCardData(
            label: 'İkindi',
            value: prayerTimes?.asr ?? '--:--',
            icon: Icons.wb_sunny_outlined,
            isNext: nextPrayerLabel == 'İkindi',
          ),
          _PrayerCardData(
            label: 'Akşam',
            value: prayerTimes?.maghrib ?? '--:--',
            icon: Icons.bedtime,
            isNext: nextPrayerLabel == 'Akşam',
          ),
          _PrayerCardData(
            label: 'Yatsı',
            value: prayerTimes?.isha ?? '--:--',
            icon: Icons.dark_mode_outlined,
            isNext: nextPrayerLabel == 'Yatsı',
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
                    isNext: card.isNext,
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
  final bool isNext;

  _PrayerCardData({
    required this.label,
    required this.value,
    required this.icon,
    this.isNext = false,
  });
}

class _InsightCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool loading;
  final bool isNext;

  const _InsightCard({
    required this.label,
    required this.value,
    required this.icon,
    this.loading = false,
    this.isNext = false,
  });

  @override
  State<_InsightCard> createState() => _InsightCardState();
}

class _InsightCardState extends State<_InsightCard> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isNext) {
      _animationController = AnimationController(
        duration: const Duration(seconds: 4),
        vsync: this,
      )..repeat();

      _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor1 = isDark 
        ? AppColors.surfaceHigh.withValues(alpha: 0.6)
        : AppColors.lightSurface.withValues(alpha: 0.9);
    final cardBgColor2 = isDark 
        ? AppColors.surface.withValues(alpha: 0.5)
        : AppColors.lightSurfaceHigh.withValues(alpha: 0.95);
    final textColor = isDark ? AppColors.white : AppColors.lightTextPrimary;
    final iconColor = isDark ? AppColors.white : AppColors.lightTextPrimary;

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
                        cardBgColor1,
                        cardBgColor2,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isDark) ...[
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
            ],
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: isDark 
                          ? AppColors.white.withValues(alpha: 0.04)
                          : AppColors.lightTextMuted.withValues(alpha: 0.2),
                    ),
                    boxShadow: widget.isNext
                        ? [
                            BoxShadow(
                              color: isDark
                                  ? AppColors.primary.withValues(alpha: 0.25)
                                  : AppColors.white.withValues(alpha: 0.15),
                              blurRadius: 32,
                              spreadRadius: -2,
                              offset: const Offset(0, 0),
                            ),
                            BoxShadow(
                              color: isDark
                                  ? AppColors.secondary.withValues(alpha: 0.15)
                                  : AppColors.white.withValues(alpha: 0.1),
                              blurRadius: 40,
                              spreadRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: isDark
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : AppColors.white.withValues(alpha: 0.05),
                              blurRadius: 24,
                              spreadRadius: -4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                  ),
                ),
              ),
            ),
            if (widget.isNext && _shimmerAnimation != null)
              AnimatedBuilder(
                animation: _shimmerAnimation!,
                builder: (context, child) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(_shimmerAnimation!.value - 1, -1),
                            end: Alignment(_shimmerAnimation!.value + 1, 1),
                            colors: [
                              Colors.transparent,
                              AppColors.white.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(widget.icon, color: iconColor),
                  const SizedBox(height: AppSpacing.sm),
                  Text(widget.label, style: AppTextStyles.bodyS.copyWith(color: textColor)),
                  const SizedBox(height: AppSpacing.xs),
                  widget.loading
                      ? SizedBox(
                          height: 12,
                          width: 48,
                          child: LinearProgressIndicator(
                            backgroundColor: isDark ? AppColors.surfaceLow : AppColors.lightSurfaceLow,
                            valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        )
                      : Text(widget.value, style: AppTextStyles.displayL.copyWith(color: textColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
