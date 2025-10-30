import 'package:json_annotation/json_annotation.dart';

part 'prayer_times_request_model.g.dart';

 @JsonSerializable()
class PrayerTimesRequest {
  final String deviceId;
  final double latitude;
  final double longitude;
  final String date;
  final String? calcMethod;
  final String? madhab;

  PrayerTimesRequest({
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.calcMethod,
    this.madhab,
  });

  factory PrayerTimesRequest.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PrayerTimesRequestToJson(this);
}