
import 'package:takvapp_mobile/core/models/device_request_model.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'package:takvapp_mobile/core/models/monthly_prayer_times_model.dart';
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

  // Sahte `getMonthlyPrayerTimes` yanıtı
  Future<MonthlyPrayerTimes> getMonthlyPrayerTimes({
    required String location,
    required int year,
    required int month,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    final dailyTimes = List.generate(daysInMonth, (index) {
      final day = index + 1;
      final date = DateTime(year, month, day);
      final weekdayIndex = date.weekday - 1;
      final weekday = weekdays[weekdayIndex];

      final baseHour = 4;
      final baseMinute = 49;
      final variation = (day % 7) * 2;
      final fajrHour = baseHour + (variation ~/ 60);
      final fajrMinute = (baseMinute + variation) % 60;

      return DailyPrayerTime(
        day: day,
        weekday: weekday,
        times: PrayerTimes(
          fajr: '${fajrHour.toString().padLeft(2, '0')}:${fajrMinute.toString().padLeft(2, '0')}',
          sunrise: '05:57',
          dhuhr: '11:59',
          asr: '15:14',
          maghrib: '17:58',
          isha: '19:10',
        ),
      );
    });

    return MonthlyPrayerTimes(
      location: location,
      year: year,
      month: month,
      dailyTimes: dailyTimes,
    );
  }
}
