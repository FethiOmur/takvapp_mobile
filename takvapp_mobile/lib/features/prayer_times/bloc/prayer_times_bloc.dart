
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';

part 'prayer_times_event.dart';
part 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  final LocationService _locationService;
  final ApiServiceInterface _apiService;

  PrayerTimesBloc(this._locationService, this._apiService)
      : super(PrayerTimesInitial()) {
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
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 4. "Karar Matrisi" - Backend'den gelen son durumu kontrol et
      final lastGeohash = event.deviceState.deviceState.lastGeohash6;
      final lastDate = event.deviceState.deviceState.lastPrayerDate;
      final lastCache = event.deviceState.deviceState.lastPrayerCache;

      // SENARYO 2: Aynı Konum, Aynı Gün ve Cache var mı?
      if (lastCache != null &&
          currentGeohash == lastGeohash &&
          currentDate == lastDate) {
        // CACHE HIT: API çağırma, backend'den gelen cache'i kullan
        emit(PrayerTimesSuccess(lastCache, isFromCache: true));
      } else {
        // CACHE MISS: API'ı çağır (Senaryo 3 veya 4)
        
        final request = PrayerTimesRequest(
          deviceId: event.deviceState.deviceIdString,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          date: currentDate,
          // TODO: Bu alanları ayarlardan alacak şekilde güncelle
          calcMethod: 'diyanet', 
          madhab: 'hanafi',
        );

        final newPrayerTimes = await _apiService.getPrayerTimes(request);
        emit(PrayerTimesSuccess(newPrayerTimes, isFromCache: false));
      }
    } catch (e) {
      emit(PrayerTimesFailure(e.toString()));
    }
  }
}
