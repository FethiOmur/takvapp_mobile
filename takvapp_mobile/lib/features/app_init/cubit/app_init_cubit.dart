
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/services/device_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
    try {
      // 1. Cihaz ID'sini al/oluştur
      final deviceId = await _deviceService.getOrCreatetDeviceId();

      // 2. Cihaz bilgilerini al
      String? platform;
      if (Platform.isAndroid) {
        platform = 'Android';
      } else if (Platform.isIOS) {
        platform = 'iOS';
      }

      final String timezone = await FlutterNativeTimezone.getLocalTimezone();
      final String locale = Intl.systemLocale;

      // 3. API için istek modelini oluştur
      final request = DeviceRequest(
        deviceId: deviceId,
        platform: platform,
        locale: locale,
        timezone: timezone,
      );

      // 4. API'ı çağır
      final deviceStateResponse = await _apiService.upsertDevice(request);

      // 5. Başarılı durumu yayınla
      emit(AppInitSuccess(deviceStateResponse));
    } catch (e) {
      emit(AppInitFailure(e.toString()));
    }
  }
}
