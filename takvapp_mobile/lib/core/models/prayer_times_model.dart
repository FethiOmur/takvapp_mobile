import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'prayer_times_model.g.dart';

 @JsonSerializable()
class PrayerTimes extends Equatable {
  final String? fajr;
  final String? sunrise;
  final String? dhuhr;
  final String? asr;
  final String? maghrib;
  final String? isha;

  const PrayerTimes({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerTimesToJson(this);

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}