
import 'package:dio/dio.dart';
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'api_service_interface.dart';

class ApiService implements ApiServiceInterface {
  final Dio _dio;

  // TODO: Bu URL'yi gerçek backend URL'si ile değiştir
  static const String _baseUrl = 'https://bburakenesdemir-muslim-api-url.com';

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<DeviceStateResponse> upsertDevice(DeviceRequest deviceRequest) async {
    try {
      final response = await _dio.post(
        '/api/device/upsert',
        data: deviceRequest.toJson(),
      );
      return DeviceStateResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('API Hatası (upsertDevice): ${e.message}');
    }
  }

  Future<PrayerTimes> getPrayerTimes(PrayerTimesRequest request) async {
    try {
      final response = await _dio.post(
        '/api/prayer-times',
        data: request.toJson(),
      );
      // Backend'in 'fresh: true' vb. içeren bir sarmalayıcı değil,
      // doğrudan PrayerTimes nesnesini döndürdüğünü varsayıyoruz.
      // Eğer farklıysa, burada parse et.
      return PrayerTimes.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('API Hatası (getPrayerTimes): ${e.message}');
    }
  }
}
