
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/services/device_service.dart';
import 'package:takvapp_mobile/core/utils/retry.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

part 'app_init_state.dart';

class AppInitCubit extends Cubit<AppInitState> {
  final DeviceService _deviceService;
  final ApiServiceInterface _apiService;

  AppInitCubit(this._deviceService, this._apiService)
      : super(AppInitInitial());

  Future<void> initializeApp() async {
    emit(AppInitLoading());
    DeviceStateResponse? cachedState;

    try {
      cachedState = await _deviceService.getCachedDeviceState();
      if (cachedState != null) {
        emit(AppInitSuccess(cachedState));
      }

      // 1. Cihaz ID'sini al/oluştur
      final deviceId = await _deviceService.getOrCreateDeviceId();

      // 2. Cihaz bilgilerini al
      String? platform;
      if (Platform.isAndroid) {
        platform = 'Android';
      } else if (Platform.isIOS) {
        platform = 'iOS';
      }

      final timezone = await FlutterNativeTimezone.getLocalTimezone();
      final locale = Intl.systemLocale;

      // 3. API için istek modelini oluştur
      final request = DeviceRequest(
        deviceId: deviceId,
        platform: platform,
        locale: locale,
        timezone: timezone,
      );

      // 4. API'ı çağır (retry ile)
      final deviceStateResponse = await retry(
        () => _apiService.upsertDevice(request),
        maxAttempts: 3,
        baseDelay: const Duration(milliseconds: 400),
      );

      await _deviceService.persistDeviceState(deviceStateResponse);

      // 5. Başarılı durumu yayınla (en güncel veri)
      emit(AppInitSuccess(deviceStateResponse));
    } catch (e) {
      if (cachedState == null) {
        emit(AppInitFailure(e.toString()));
      }
    }
  }
}
