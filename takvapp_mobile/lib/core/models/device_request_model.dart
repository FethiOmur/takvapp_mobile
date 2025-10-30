import 'package:json_annotation/json_annotation.dart';

part 'device_request_model.g.dart';

 @JsonSerializable()
class DeviceRequest {
  final String deviceId;
  final String? platform;
  final String? locale;
  final String? timezone;

  DeviceRequest({
    required this.deviceId,
    this.platform,
    this.locale,
    this.timezone,
  });

  factory DeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceRequestToJson(this);
}