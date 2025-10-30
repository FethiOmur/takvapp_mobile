import './prayer_times_model.dart';

class Device {
  final String id;
  // Add other device properties here

  Device({required this.id});
}

class DeviceState {
  // Add device state properties here
  final PrayerTimes? lastPrayerCache;

  DeviceState({this.lastPrayerCache});
}