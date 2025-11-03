
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'api_service_interface.dart';

// Bu sınıf, ApiService'in sahte versiyonudur.
// Hiçbir ağ isteği yapmaz, anında başarılı yanıt döner.
class FakeApiService implements ApiServiceInterface {
  
  // Sahte namaz vakitleri verisi
  final _fakePrayerTimes = PrayerTimes(
    fajr: '06:30',
    sunrise: '07:45',
    dhuhr: '12:30',
    asr: '15:15',
    maghrib: '17:45',
    isha: '19:00',
  );

  // Sahte `upsertDevice` yanıtı (Senaryo 1: İlk Kullanım)
  @override
  Future<DeviceStateResponse> upsertDevice(DeviceRequest deviceRequest) async {
    // Backend'in hazır olmasını simüle etmek için 1 saniye bekle
    await Future.delayed(const Duration(seconds: 1));

    // Bu, "Senaryo 1: İlk Kullanım" senaryosuna uyan
    // "daha önce hiç konum veya namaz vakti alınmamış" sahte bir yanıttır.
    final now = DateTime.now();
    return DeviceStateResponse(
      deviceId: 1,
      deviceIdString: deviceRequest.deviceId,
      platform: deviceRequest.platform,
      locale: deviceRequest.locale,
      timezone: deviceRequest.timezone,
      createdAt: now,
      lastSeenAt: now,
      deviceState: DeviceState(
        id: 1,
        lastLocation: null,
        lastPrayerCache: null, // Cache yok
        lastPrayerDate: null,  // Tarih yok
        lastGeohash6: null,    // Geohash yok
        lastUpdatedAt: now,
        createdAt: now,
      ),
    );
  }

  // Sahte `getPrayerTimes` yanıtı
  @override
  Future<PrayerTimes> getPrayerTimes(PrayerTimesRequest request) async {
    // 1 saniye bekle
    await Future.delayed(const Duration(seconds: 1));
    
    // Doğrudan sahte namaz vakitlerini dön
    return _fakePrayerTimes;
  }
}
