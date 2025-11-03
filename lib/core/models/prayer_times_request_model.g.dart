// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimesRequest _$PrayerTimesRequestFromJson(Map<String, dynamic> json) =>
    PrayerTimesRequest(
      deviceId: json['deviceId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      date: json['date'] as String,
      calcMethod: json['calcMethod'] as String?,
      madhab: json['madhab'] as String?,
    );

Map<String, dynamic> _$PrayerTimesRequestToJson(PrayerTimesRequest instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'date': instance.date,
      'calcMethod': instance.calcMethod,
      'madhab': instance.madhab,
    };
