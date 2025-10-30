
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';

abstract class ApiServiceInterface {
  Future<DeviceStateResponse> upsertDevice(DeviceRequest deviceRequest);
  Future<PrayerTimes> getPrayerTimes(PrayerTimesRequest request);
}
