
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/device_state_snapshot.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/core/services/prayer_cache_service.dart';
import 'package:takvapp_mobile/core/utils/retry.dart';

part 'prayer_times_event.dart';
part 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  final LocationService _locationService;
  final PrayerCacheService _cacheService;
  final ApiServiceInterface _apiService;

  PrayerTimesBloc(
    this._locationService,
    this._cacheService,
    this._apiService,
  ) : super(PrayerTimesInitial()) {
    on<FetchPrayerTimes>(_onFetchPrayerTimes);
  }

  Future<void> _onFetchPrayerTimes(
      FetchPrayerTimes event, Emitter<PrayerTimesState> emit) async {
    emit(PrayerTimesLoading());
    try {
      // 1. Mevcut konumu al (veya varsayılan İstanbul)
      final currentPosition = await _locationService.getCurrentLocation();

      // 2. Mevcut Geohash'i hesapla
      final currentGeohash = _locationService.calculateGeohash(
          currentPosition.latitude, currentPosition.longitude);

      // 3. Mevcut tarihi al
      final now = DateTime.now();
      final currentDateKey = DateFormat('yyyy-MM-dd').format(now);

      // 4. "Karar Matrisi" - önce yerel cache'i, sonra backend cache'ini kontrol et
      final localCache = await _cacheService.readEntry(currentGeohash, now);
      if (localCache != null) {
        final locationName = await _locationService.getPlacemark(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        emit(
          PrayerTimesSuccess(
            localCache.prayerTimes,
            locationName,
            isFromCache: true,
          ),
        );
        return;
      }

      final snapshot = event.deviceState.toSnapshot();

      if (snapshot.hasCacheFor(now, currentGeohash)) {
        final locationName = await _locationService.getPlacemark(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        emit(
          PrayerTimesSuccess(
            snapshot.cachedPrayerTimes!,
            locationName,
            isFromCache: true,
          ),
        );
      } else {
        // CACHE MISS: API'ı çağır (Senaryo 3 veya 4)

        final request = PrayerTimesRequest(
          deviceId: event.deviceState.deviceIdString,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          date: currentDateKey,
          // TODO: Bu alanları ayarlardan alacak şekilde güncelle
          calcMethod: 'diyanet', 
          madhab: 'hanafi',
        );

        final newPrayerTimes = await retry(
          () => _apiService.getPrayerTimes(request),
          maxAttempts: 3,
          baseDelay: const Duration(milliseconds: 400),
        );

        await _cacheService.writeEntry(
          geohash: currentGeohash,
          date: now,
          prayerTimes: newPrayerTimes,
        );

        final locationName = await _locationService.getPlacemark(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        emit(PrayerTimesSuccess(newPrayerTimes, locationName, isFromCache: false));
      }
    } catch (e) {
      emit(PrayerTimesFailure(e.toString()));
    }
  }
}
