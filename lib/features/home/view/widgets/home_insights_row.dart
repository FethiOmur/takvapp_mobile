import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        final sunrise = state is PrayerTimesSuccess ? state.prayerTimes.sunrise ?? '--:--' : '--:--';
        final fajr = state is PrayerTimesSuccess ? state.prayerTimes.fajr ?? '--:--' : '--:--';
        final maghrib = state is PrayerTimesSuccess ? state.prayerTimes.maghrib ?? '--:--' : '--:--';

        return Row(
          children: [
            Expanded(
              child: _InsightCard(
                label: 'Sunrise',
                value: sunrise,
                icon: Icons.wb_sunny,
                gradient: const [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                loading: isLoading,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _InsightCard(
                label: 'Fajr',
                value: fajr,
                icon: Icons.nightlight_round,
                gradient: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                loading: isLoading,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _InsightCard(
                label: 'Maghrib',
                value: maghrib,
                icon: Icons.nightlight_outlined,
                gradient: const [Color(0xFF43CEA2), Color(0xFF185A9D)],
                loading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool loading;
  final List<Color> gradient;

  const _InsightCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white24),
      ),
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
    );
  }
}
