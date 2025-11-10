import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/models/prayer_times_card_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/badge_cached.dart';

class PrayerTimesCardNew extends StatefulWidget {
  final PrayerTimes prayerTimes;
  final String city;
  final String? country;
  final bool isCached;
  final ValueChanged<PrayerKey>? onSelect;
  final VoidCallback? onRefresh;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;

  const PrayerTimesCardNew({
    super.key,
    required this.prayerTimes,
    required this.city,
    this.country,
    required this.isCached,
    this.onSelect,
    this.onRefresh,
    this.padding,
    this.minHeight,
  });

  @override
  State<PrayerTimesCardNew> createState() => _PrayerTimesCardNewState();
}

class _PrayerTimesCardNewState extends State<PrayerTimesCardNew> {
  PrayerKey _selected = PrayerKey.fajr;

  @override
  void initState() {
    super.initState();
    _updateSelectedToNext();
  }

  @override
  void didUpdateWidget(PrayerTimesCardNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prayerTimes != widget.prayerTimes) {
      _updateSelectedToNext();
    }
  }

  void _updateSelectedToNext() {
    final now = DateTime.now();
    final times = _parseTimes();
    final next = _calculateNextPrayer(times, now);
    if (next != null && mounted) {
      setState(() {
        _selected = next;
      });
    }
  }

  Map<PrayerKey, DateTime> _parseTimes() {
    final now = DateTime.now();
    final times = <PrayerKey, DateTime>{};

    void parseTime(String? timeStr, PrayerKey key) {
      if (timeStr == null) return;
      try {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          times[key] = DateTime(now.year, now.month, now.day, hour, minute);
        }
      } catch (_) {}
    }

    parseTime(widget.prayerTimes.fajr, PrayerKey.fajr);
    parseTime(widget.prayerTimes.sunrise, PrayerKey.sunrise);
    parseTime(widget.prayerTimes.dhuhr, PrayerKey.dhuhr);
    parseTime(widget.prayerTimes.asr, PrayerKey.asr);
    parseTime(widget.prayerTimes.maghrib, PrayerKey.maghrib);
    parseTime(widget.prayerTimes.isha, PrayerKey.isha);

    return times;
  }

  PrayerKey? _calculateNextPrayer(Map<PrayerKey, DateTime> times, DateTime now) {
    PrayerKey? nextKey;
    Duration? minDuration;

    for (final entry in times.entries) {
      var targetTime = entry.value;
      if (targetTime.isBefore(now)) {
        targetTime = targetTime.add(const Duration(days: 1));
      }
      final duration = targetTime.difference(now);
      if (minDuration == null || duration < minDuration) {
        minDuration = duration;
        nextKey = entry.key;
      }
    }

    return nextKey ?? PrayerKey.fajr;
  }

  String _getBackgroundSvg(PrayerKey key) {
    switch (key) {
      case PrayerKey.fajr:
        return 'assets/images/prayer_times/night.svg';
      case PrayerKey.sunrise:
        return 'assets/images/prayer_times/sunrise.svg';
      case PrayerKey.dhuhr:
      case PrayerKey.asr:
        return 'assets/images/prayer_times/afternoon.svg';
      case PrayerKey.maghrib:
        return 'assets/images/prayer_times/evening.svg';
      case PrayerKey.isha:
        return 'assets/images/prayer_times/night.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final times = _parseTimes();
    final selectedTime = times[_selected];

    final borderRadius = BorderRadius.circular(36);

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Container(
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
                    _getBackgroundSvg(_selected),
                    fit: BoxFit.cover,
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
                          AppColors.white.withValues(alpha: 0.02),
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
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildPrayerIcon(),
                        const Spacer(),
                        if (widget.isCached) const BadgeCached(),
                        if (widget.onRefresh != null) ...[
                          const SizedBox(width: AppSpacing.md),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh_rounded,
                              size: 20,
                              color: AppColors.white,
                            ),
                            onPressed: widget.onRefresh,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTime(selectedTime),
                    const SizedBox(height: AppSpacing.md),
                    _buildLocation(),
                    const SizedBox(height: AppSpacing.xs),
                    _buildDateTime(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerIcon() {
    return Icon(
      _getPrayerIcon(_selected),
      size: 32,
      color: AppColors.white,
    );
  }

  Widget _buildTime(DateTime? time) {
    final timeStr = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        timeStr,
        key: ValueKey(timeStr),
        style: AppTextStyles.displayXL.copyWith(
          fontSize: 56,
          fontWeight: FontWeight.w300,
          color: AppColors.white,
          height: 1.0,
          letterSpacing: -1.0,
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          widget.city,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTime() {
    final now = DateTime.now();
    final weekday = _getWeekdayName(now.weekday);
    final month = _getMonthName(now.month);
    final day = now.day;
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    final dateTimeStr = '$weekday, $month $day, $displayHour:$minute $period';

    return Text(
      dateTimeStr,
      style: AppTextStyles.bodyS.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Paz', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt'];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
    return months[month - 1];
  }

  IconData _getPrayerIcon(PrayerKey key) {
    switch (key) {
      case PrayerKey.fajr:
      case PrayerKey.maghrib:
      case PrayerKey.isha:
        return Icons.nightlight_round;
      case PrayerKey.sunrise:
        return Icons.wb_twilight;
      case PrayerKey.dhuhr:
      case PrayerKey.asr:
        return Icons.wb_sunny;
    }
  }
}

