import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/prayer_times_card_new.dart';
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

        if (isLoading) {
          return _LoadingCard();
        }

        return PrayerTimesCardNew(
          prayerTimes: data,
          city: location,
          isCached: fromCache,
        );
      },
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.surfaceHigh.withValues(alpha: 0.5),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
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
