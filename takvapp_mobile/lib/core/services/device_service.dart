
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  final Uuid _uuid = const Uuid();
  static const _deviceIdKey = 'device_id_key';

  Future<String> getOrCreatetDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      deviceId = _uuid.v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }
}
