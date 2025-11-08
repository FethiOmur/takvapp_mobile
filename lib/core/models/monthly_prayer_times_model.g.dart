// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_prayer_times_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyPrayerTimes _$MonthlyPrayerTimesFromJson(Map<String, dynamic> json) =>
    MonthlyPrayerTimes(
      location: json['location'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      dailyTimes: (json['dailyTimes'] as List<dynamic>)
          .map((e) => DailyPrayerTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonthlyPrayerTimesToJson(MonthlyPrayerTimes instance) =>
    <String, dynamic>{
      'location': instance.location,
      'year': instance.year,
      'month': instance.month,
      'dailyTimes': instance.dailyTimes,
    };

DailyPrayerTime _$DailyPrayerTimeFromJson(Map<String, dynamic> json) =>
    DailyPrayerTime(
      day: (json['day'] as num).toInt(),
      weekday: json['weekday'] as String,
      times: PrayerTimes.fromJson(json['times'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyPrayerTimeToJson(DailyPrayerTime instance) =>
    <String, dynamic>{
      'day': instance.day,
      'weekday': instance.weekday,
      'times': instance.times,
    };
