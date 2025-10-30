import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:takvapp_mobile/features/home/view/widgets/prayer_time_model.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: AppColors.darkGrey.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
          builder: (context, state) {
            if (state is PrayerTimesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PrayerTimesFailure) {
              return Center(child: Text(state.error, style: AppTextStyles.bodyText1));
            }
            if (state is PrayerTimesSuccess) {
              final prayerTimes = [
                PrayerTime(name: 'Fajr', time: state.prayerTimes.fajr ?? '-', iconUrl: 'assets/images/fajr.png'),
                PrayerTime(name: 'Dhuhr', time: state.prayerTimes.dhuhr ?? '-', iconUrl: 'assets/images/dhuhr.png'),
                PrayerTime(name: 'Asr', time: state.prayerTimes.asr ?? '-', iconUrl: 'assets/images/asr.png'),
                PrayerTime(name: 'Maghrib', time: state.prayerTimes.maghrib ?? '-', iconUrl: 'assets/images/maghrib.png', isCurrent: true),
                PrayerTime(name: 'Isha', time: state.prayerTimes.isha ?? '-', iconUrl: 'assets/images/isha.png'),
              ];

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('17:21', style: AppTextStyles.headline1),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.white, size: 16),
                              SizedBox(width: 4),
                              Text('Istanbul, Turkey', style: AppTextStyles.bodyText2),
                            ],
                          ),
                          Text('Maghrib will begin in -00:37:25', style: AppTextStyles.caption),
                        ],
                      ),
                      Image.asset('assets/images/prayer_time_icon.png', height: 72),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: prayerTimes.map((pt) => Expanded(child: _buildPrayerTime(pt))).toList(),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPrayerTime(PrayerTime prayerTime) {
    return Column(
      children: [
        Text(
          prayerTime.name,
          style: prayerTime.isCurrent ? AppTextStyles.bodyText1.copyWith(color: AppColors.primary) : AppTextStyles.bodyText1,
        ),
        const SizedBox(height: 4),
        Image.asset(prayerTime.iconUrl, height: 24),
        const SizedBox(height: 4),
        Text(
          prayerTime.time,
          style: prayerTime.isCurrent ? AppTextStyles.bodyText2.copyWith(color: AppColors.primary) : AppTextStyles.bodyText2,
        ),
      ],
    );
  }
}
