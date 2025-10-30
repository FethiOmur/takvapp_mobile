// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRequest _$DeviceRequestFromJson(Map<String, dynamic> json) =>
    DeviceRequest(
      deviceId: json['deviceId'] as String,
      platform: json['platform'] as String?,
      locale: json['locale'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$DeviceRequestToJson(DeviceRequest instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'locale': instance.locale,
      'timezone': instance.timezone,
    };
