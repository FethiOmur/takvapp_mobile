part of 'prayer_times_bloc.dart';

abstract class PrayerTimesEvent extends Equatable {
  const PrayerTimesEvent();
  @override
  List<Object> get props => [];
}

class FetchPrayerTimes extends PrayerTimesEvent {
  final DeviceStateResponse deviceState;
  const FetchPrayerTimes(this.deviceState);
  @override
  List<Object> get props => [deviceState];
}