part of 'prayer_times_bloc.dart';

abstract class PrayerTimesState extends Equatable {
  const PrayerTimesState();
  @override
  List<Object> get props => [];
}

class PrayerTimesInitial extends PrayerTimesState {}

class PrayerTimesLoading extends PrayerTimesState {}

class PrayerTimesSuccess extends PrayerTimesState {
  final PrayerTimes prayerTimes;
  final String locationName;
  final bool isFromCache;
  const PrayerTimesSuccess(this.prayerTimes, this.locationName, {this.isFromCache = false});
  @override
  List<Object> get props => [prayerTimes, locationName, isFromCache];
}

class PrayerTimesFailure extends PrayerTimesState {
  final String error;
  const PrayerTimesFailure(this.error);
  @override
  List<Object> get props => [error];
}