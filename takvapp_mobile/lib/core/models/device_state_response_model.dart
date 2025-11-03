import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'prayer_times_model.dart';

part 'device_state_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceStateResponse extends Equatable {
  final int? deviceId;
  final String deviceIdString;
  final String? platform;
  final String? locale;
  final String? timezone;
  @JsonKey(fromJson: _fromIso, toJson: _toIso)
  final DateTime? createdAt;
  @JsonKey(fromJson: _fromIso, toJson: _toIso)
  final DateTime? lastSeenAt;
  final DeviceState? deviceState;

  const DeviceStateResponse({
    this.deviceId,
    required this.deviceIdString,
    this.platform,
    this.locale,
    this.timezone,
    this.createdAt,
    this.lastSeenAt,
    this.deviceState,
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
        deviceState,
      ];
}

@JsonSerializable(explicitToJson: true)
class DeviceState extends Equatable {
  final int? id;
  final Location? lastLocation;
  final PrayerTimes? lastPrayerCache;
  @JsonKey(fromJson: _fromDateOnly, toJson: _toDateOnly)
  final DateTime? lastPrayerDate;
  final String? lastGeohash6;
  @JsonKey(fromJson: _fromIso, toJson: _toIso)
  final DateTime? lastUpdatedAt;
  @JsonKey(fromJson: _fromIso, toJson: _toIso)
  final DateTime? createdAt;

  const DeviceState({
    this.id,
    this.lastLocation,
    this.lastPrayerCache,
    this.lastPrayerDate,
    this.lastGeohash6,
    this.lastUpdatedAt,
    this.createdAt,
  });

  factory DeviceState.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStateToJson(this);

  @override
  List<Object?> get props => [
        id,
        lastLocation,
        lastPrayerCache,
        lastPrayerDate,
        lastGeohash6,
        lastUpdatedAt,
        createdAt,
      ];
}

@JsonSerializable()
class Location extends Equatable {
  final int? id;
  final double latitude;
  final double longitude;
  final String? geohash6;

  const Location({
    this.id,
    required this.latitude,
    required this.longitude,
    this.geohash6,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [id, latitude, longitude, geohash6];
}

DateTime? _fromIso(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String? _toIso(DateTime? value) => value?.toIso8601String();

DateTime? _fromDateOnly(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}

String? _toDateOnly(DateTime? value) {
  final isoString = value?.toIso8601String();
  return isoString?.split('T').first;
}
