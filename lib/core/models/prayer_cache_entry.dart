import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'prayer_times_model.dart';

part 'prayer_cache_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class PrayerCacheEntry extends Equatable {
  final PrayerTimes prayerTimes;
  final String geohash6;
  @JsonKey(fromJson: _fromDateOnly, toJson: _toDateOnly)
  final DateTime cachedForDate;
  @JsonKey(fromJson: _fromIso, toJson: _toIso)
  final DateTime storedAt;

  const PrayerCacheEntry({
    required this.prayerTimes,
    required this.geohash6,
    required this.cachedForDate,
    required this.storedAt,
  });

  factory PrayerCacheEntry.fromJson(Map<String, dynamic> json) =>
      _$PrayerCacheEntryFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerCacheEntryToJson(this);

  bool isValidFor(DateTime date, String geohash) =>
      geohash6 == geohash && _isSameDate(cachedForDate, date);

  @override
  List<Object?> get props => [prayerTimes, geohash6, cachedForDate, storedAt];

  static bool _isSameDate(DateTime left, DateTime right) =>
      left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

DateTime _fromDateOnly(String value) => DateTime.parse(value);

String _toDateOnly(DateTime value) => value.toIso8601String().split('T').first;

DateTime _fromIso(String value) => DateTime.parse(value);

String _toIso(DateTime value) => value.toIso8601String();
