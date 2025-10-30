// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimes _$PrayerTimesFromJson(Map<String, dynamic> json) => PrayerTimes(
  fajr: json['fajr'] as String?,
  sunrise: json['sunrise'] as String?,
  dhuhr: json['dhuhr'] as String?,
  asr: json['asr'] as String?,
  maghrib: json['maghrib'] as String?,
  isha: json['isha'] as String?,
);

Map<String, dynamic> _$PrayerTimesToJson(PrayerTimes instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
    };
