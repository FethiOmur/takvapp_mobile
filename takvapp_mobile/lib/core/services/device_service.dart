
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:takvapp_mobile/core/models/device_state_response_model.dart';

class DeviceService {
  final Uuid _uuid = const Uuid();
  static const _deviceIdKey = 'device_id_key';
  static const _deviceStateKey = 'device_state_cache';

  /// Returns the persisted device id or generates a new UUID on first launch.
  Future<String> getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _uuid.v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// Persists the latest device snapshot so the app can recover offline.
  Future<void> persistDeviceState(DeviceStateResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = jsonEncode(response.toJson());
    await prefs.setString(_deviceStateKey, serialized);
  }

  /// Returns the most recently cached device state, if any.
  Future<DeviceStateResponse?> getCachedDeviceState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_deviceStateKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
      return DeviceStateResponse.fromJson(decoded);
    } catch (_) {
      await prefs.remove(_deviceStateKey);
      return null;
    }
  }

  Future<void> clearCachedDeviceState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceStateKey);
  }
}
