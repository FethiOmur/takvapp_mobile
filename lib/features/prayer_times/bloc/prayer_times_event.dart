part of 'prayer_times_bloc.dart';

abstract class PrayerTimesEvent extends Equatable {
  const PrayerTimesEvent();
  @override
  List<Object?> get props => [];
}

class FetchPrayerTimes extends PrayerTimesEvent {
  final DeviceStateResponse deviceState;
  const FetchPrayerTimes(this.deviceState);
  @override
  List<Object?> get props => [deviceState];
}

class RefreshPrayerTimesIfDayChanged extends PrayerTimesEvent {
  final DateTime referenceTime;
  final DeviceStateResponse? deviceState;

  const RefreshPrayerTimesIfDayChanged({
    required this.referenceTime,
    this.deviceState,
  });

  @override
  List<Object?> get props => [referenceTime, deviceState];
}

class RefreshPrayerTimes extends PrayerTimesEvent {
  final DeviceStateResponse deviceState;
  final bool force;

  const RefreshPrayerTimes(this.deviceState, {this.force = false});

  @override
  List<Object?> get props => [deviceState, force];
}
