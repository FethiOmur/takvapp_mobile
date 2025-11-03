import 'package:equatable/equatable.dart';

import 'device_state_response_model.dart';
import 'prayer_times_model.dart';

/// A lightweight representation of the device cache state we receive
/// from the backend. It allows the UI layer to make quick decisions
/// about whether fresh data is required.
class DeviceStateSnapshot extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? geohash6;
  final PrayerTimes? cachedPrayerTimes;
  final DateTime? cachedPrayerDate;
  final DateTime? lastUpdatedAt;

  const DeviceStateSnapshot({
    this.latitude,
    this.longitude,
    this.geohash6,
    this.cachedPrayerTimes,
    this.cachedPrayerDate,
    this.lastUpdatedAt,
  });

  /// Provides an easy way to convert API responses into snapshot data
  /// that can drive cache and refresh decisions in the presentation layer.
  factory DeviceStateSnapshot.fromResponse(DeviceStateResponse response) {
    final state = response.deviceState;
    final location = state?.lastLocation;
    final effectiveGeohash = state?.lastGeohash6 ?? location?.geohash6;

    return DeviceStateSnapshot(
      latitude: location?.latitude,
      longitude: location?.longitude,
      geohash6: effectiveGeohash,
      cachedPrayerTimes: state?.lastPrayerCache,
      cachedPrayerDate: state?.lastPrayerDate,
      lastUpdatedAt: state?.lastUpdatedAt ?? state?.createdAt,
    );
  }

  static const DeviceStateSnapshot empty = DeviceStateSnapshot();

  bool get hasLocation => latitude != null && longitude != null;

  bool hasCacheFor(DateTime date, String geohash) {
    if (cachedPrayerTimes == null || cachedPrayerDate == null) {
      return false;
    }
    final matchesGeohash = geohash6 != null && geohash6 == geohash;
    final matchesDay = _isSameDate(cachedPrayerDate!, date);
    return matchesGeohash && matchesDay;
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        geohash6,
        cachedPrayerTimes,
        cachedPrayerDate,
        lastUpdatedAt,
      ];

  static bool _isSameDate(DateTime left, DateTime right) =>
      left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

extension DeviceStateResponseSnapshotX on DeviceStateResponse {
  DeviceStateSnapshot toSnapshot() => DeviceStateSnapshot.fromResponse(this);
}
