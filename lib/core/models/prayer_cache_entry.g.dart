// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_cache_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerCacheEntry _$PrayerCacheEntryFromJson(Map<String, dynamic> json) =>
    PrayerCacheEntry(
      prayerTimes: PrayerTimes.fromJson(
        json['prayerTimes'] as Map<String, dynamic>,
      ),
      geohash6: json['geohash6'] as String,
      cachedForDate: _fromDateOnly(json['cachedForDate'] as String),
      storedAt: _fromIso(json['storedAt'] as String),
    );

Map<String, dynamic> _$PrayerCacheEntryToJson(PrayerCacheEntry instance) =>
    <String, dynamic>{
      'prayerTimes': instance.prayerTimes.toJson(),
      'geohash6': instance.geohash6,
      'cachedForDate': _toDateOnly(instance.cachedForDate),
      'storedAt': _toIso(instance.storedAt),
    };
