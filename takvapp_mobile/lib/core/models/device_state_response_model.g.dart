// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_state_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceStateResponse _$DeviceStateResponseFromJson(Map<String, dynamic> json) =>
    DeviceStateResponse(
      deviceId: (json['deviceId'] as num).toInt(),
      deviceIdString: json['deviceIdString'] as String,
      platform: json['platform'] as String?,
      locale: json['locale'] as String?,
      timezone: json['timezone'] as String?,
      createdAt: json['createdAt'] as String,
      lastSeenAt: json['lastSeenAt'] as String,
      deviceState: DeviceState.fromJson(
        json['deviceState'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DeviceStateResponseToJson(
  DeviceStateResponse instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'deviceIdString': instance.deviceIdString,
  'platform': instance.platform,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'createdAt': instance.createdAt,
  'lastSeenAt': instance.lastSeenAt,
  'deviceState': instance.deviceState.toJson(),
};

DeviceState _$DeviceStateFromJson(Map<String, dynamic> json) => DeviceState(
  id: (json['id'] as num).toInt(),
  lastLocation: json['lastLocation'] == null
      ? null
      : Location.fromJson(json['lastLocation'] as Map<String, dynamic>),
  lastPrayerCache: json['lastPrayerCache'] == null
      ? null
      : PrayerTimes.fromJson(json['lastPrayerCache'] as Map<String, dynamic>),
  lastPrayerDate: json['lastPrayerDate'] as String?,
  lastGeohash6: json['lastGeohash6'] as String?,
  lastUpdatedAt: json['lastUpdatedAt'] as String,
);

Map<String, dynamic> _$DeviceStateToJson(DeviceState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lastLocation': instance.lastLocation?.toJson(),
      'lastPrayerCache': instance.lastPrayerCache?.toJson(),
      'lastPrayerDate': instance.lastPrayerDate,
      'lastGeohash6': instance.lastGeohash6,
      'lastUpdatedAt': instance.lastUpdatedAt,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  id: (json['id'] as num).toInt(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  geohash6: json['geohash6'] as String,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'id': instance.id,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'geohash6': instance.geohash6,
};
