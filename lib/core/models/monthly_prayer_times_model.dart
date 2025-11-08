import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';

part 'monthly_prayer_times_model.g.dart';

@JsonSerializable()
class MonthlyPrayerTimes extends Equatable {
  final String location;
  final int year;
  final int month;
  final List<DailyPrayerTime> dailyTimes;

  const MonthlyPrayerTimes({
    required this.location,
    required this.year,
    required this.month,
    required this.dailyTimes,
  });

  factory MonthlyPrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$MonthlyPrayerTimesFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyPrayerTimesToJson(this);

  @override
  List<Object?> get props => [location, year, month, dailyTimes];
}

@JsonSerializable()
class DailyPrayerTime extends Equatable {
  final int day;
  final String weekday;
  final PrayerTimes times;

  const DailyPrayerTime({
    required this.day,
    required this.weekday,
    required this.times,
  });

  factory DailyPrayerTime.fromJson(Map<String, dynamic> json) =>
      _$DailyPrayerTimeFromJson(json);
  Map<String, dynamic> toJson() => _$DailyPrayerTimeToJson(this);

  @override
  List<Object?> get props => [day, weekday, times];
}

