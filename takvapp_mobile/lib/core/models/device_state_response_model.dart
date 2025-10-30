import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'prayer_times_model.dart';

part 'device_state_response_model.g.dart';

 @JsonSerializable(explicitToJson: true)
class DeviceStateResponse extends Equatable {
  final int deviceId;
  final String deviceIdString;
  final String? platform;
  final String? locale;
  final String? timezone;
  final String createdAt;
  final String lastSeenAt;
  final DeviceState deviceState;

  const DeviceStateResponse({
    required this.deviceId,
    required this.deviceIdString,
    this.platform,
    this.locale,
    this.timezone,
    required this.createdAt,
    required this.lastSeenAt,
    required this.deviceState,
  });

  factory DeviceStateResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceStateResponseToJson(this);

  @override
  List<Object?> get props => [
        deviceId,
        deviceIdString,
        platform,
        locale,
        timezone,
        createdAt,
        lastSeenAt,
        deviceState
      ];
}

 @JsonSerializable(explicitToJson: true)
class DeviceState extends Equatable {
  final int id;
  final Location? lastLocation;
  @JsonKey(name: 'lastPrayerCache', nullable: true)
  final PrayerTimes? lastPrayerCache;
  final String? lastPrayerDate;
  final String? lastGeohash6;
  final String lastUpdatedAt;

  const DeviceState({
    required this.id,
    this.lastLocation,
    this.lastPrayerCache,
    this.lastPrayerDate,
    this.lastGeohash6,
    required this.lastUpdatedAt,
  });

  factory DeviceState.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceStateToJson(this);

  @override
  List<Object?> get props =>
      [id, lastLocation, lastPrayerCache, lastPrayerDate, lastGeohash6, lastUpdatedAt];
}

 @JsonSerializable()
class Location extends Equatable {
  final int id;
  final double latitude;
  final double longitude;
  final String geohash6;

  const Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.geohash6,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [id, latitude, longitude, geohash6];
}