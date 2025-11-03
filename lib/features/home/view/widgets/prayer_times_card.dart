import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesFailure) {
          return _ErrorCard(message: state.error);
        }

        final bool isLoading = state is PrayerTimesLoading || state is PrayerTimesInitial;
        final PrayerTimes data = state is PrayerTimesSuccess ? state.prayerTimes : _demoPrayerTimes;
        final String location = state is PrayerTimesSuccess ? state.locationName : 'Istanbul, Turkey';
        final bool fromCache = state is PrayerTimesSuccess ? state.isFromCache : false;

        return _PrayerHero(
          prayerTimes: data,
          locationLabel: location,
          fromCache: fromCache,
          isLoading: isLoading,
        );
      },
    );
  }
}

class _PrayerHero extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final String locationLabel;
  final bool fromCache;
  final bool isLoading;

  const _PrayerHero({
    required this.prayerTimes,
    required this.locationLabel,
    required this.fromCache,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final next = _resolveNextPrayer(prayerTimes);
    final segments = _buildSegments(prayerTimes);

    return Container(
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg + 6),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 16)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              placeholderBuilder: (context) => Container(color: AppColors.surfaceLow),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC111827), Color(0xE61C2538)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.lightBlueAccent, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            locationLabel,
                            style: AppTextStyles.bodyM.copyWith(color: AppColors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: fromCache ? Colors.white24 : Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            fromCache ? 'Cached' : 'Fresh',
                            style:
                                AppTextStyles.label.copyWith(color: fromCache ? AppColors.white : AppColors.background),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (next != null) ...[
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              next.name,
                              style: AppTextStyles.bodyS.copyWith(color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text('-${_formatDuration(next.countdown)}', style: AppTextStyles.bodyS),
                          ),
                        ],
                      ),
                      Text(next.time ?? '--:--', style: AppTextStyles.displayXL.copyWith(fontSize: 46)),
                    ],
                  ],
                ),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: segments
                      .map((segment) => _PrayerChip(
                            segment: segment,
                            isActive: segment.name == next?.name,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  List<_PrayerSegment> _buildSegments(PrayerTimes times) {
    return [
      _PrayerSegment('Fajr', times.fajr, Icons.nightlight_round),
      _PrayerSegment('Sunrise', times.sunrise, Icons.wb_twilight),
      _PrayerSegment('Dhuhr', times.dhuhr, Icons.wb_sunny),
      _PrayerSegment('Asr', times.asr, Icons.wb_sunny_outlined),
      _PrayerSegment('Maghrib', times.maghrib, Icons.bedtime),
      _PrayerSegment('Isha', times.isha, Icons.dark_mode_outlined),
    ];
  }

  _NextPrayer? _resolveNextPrayer(PrayerTimes times) {
    final now = DateTime.now();
    final ordered = {
      'Fajr': times.fajr,
      'Sunrise': times.sunrise,
      'Dhuhr': times.dhuhr,
      'Asr': times.asr,
      'Maghrib': times.maghrib,
      'Isha': times.isha,
    };

    Duration? best;
    String? selectedName;
    String? selectedTime;

    for (final entry in ordered.entries) {
      final value = entry.value;
      if (value == null) continue;
      final parsed = DateFormat('HH:mm').parse(value);
      var candidate = DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
      if (candidate.isBefore(now)) candidate = candidate.add(const Duration(days: 1));
      final diff = candidate.difference(now);
      if (best == null || diff < best) {
        best = diff;
        selectedName = entry.key;
        selectedTime = value;
      }
    }

    if (selectedName == null || best == null) return null;
    return _NextPrayer(name: selectedName, time: selectedTime, countdown: best);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.abs().toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).abs().toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

class _PrayerChip extends StatelessWidget {
  final _PrayerSegment segment;
  final bool isActive;

  const _PrayerChip({required this.segment, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: isActive ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isActive ? Colors.lightBlueAccent : Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(segment.icon, color: Colors.white70, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(segment.name, style: AppTextStyles.bodyS.copyWith(color: AppColors.white)),
              Text(segment.time ?? '--:--', style: AppTextStyles.bodyS.copyWith(color: AppColors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerSegment {
  final String name;
  final String? time;
  final IconData icon;

  _PrayerSegment(this.name, this.time, this.icon);
}

class _NextPrayer {
  final String name;
  final String? time;
  final Duration countdown;

  _NextPrayer({required this.name, required this.time, required this.countdown});
}

const _demoPrayerTimes = PrayerTimes(
  fajr: '04:49',
  sunrise: '05:57',
  dhuhr: '12:30',
  asr: '15:15',
  maghrib: '17:58',
  isha: '19:10',
);

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.surfaceHigh,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Prayer times unavailable', style: AppTextStyles.headingM),
                const SizedBox(height: AppSpacing.xs),
                Text(message, style: AppTextStyles.bodyS),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
