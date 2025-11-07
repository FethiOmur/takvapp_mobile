
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:takvapp_mobile/core/api/api_service_interface.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/models/device_state_snapshot.dart';
import 'package:takvapp_mobile/core/models/prayer_cache_entry.dart';
import 'package:takvapp_mobile/core/models/prayer_times_model.dart';
import 'package:takvapp_mobile/core/models/prayer_times_request_model.dart';
import 'package:takvapp_mobile/core/services/background_task_service.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/core/services/prayer_cache_service.dart';
import 'package:takvapp_mobile/core/utils/retry.dart';

part 'prayer_times_event.dart';
part 'prayer_times_state.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  final LocationService _locationService;
  final PrayerCacheService _cacheService;
  final ApiServiceInterface _apiService;
  final BackgroundTaskService _backgroundTaskService;

  DeviceStateResponse? _lastDeviceState;
  DateTime? _lastRefreshDate;
  DateTime? _lastSuccessfulRefreshDay;

  DateTime? get lastRefreshDate => _lastRefreshDate;

  PrayerTimesBloc(
    this._locationService,
    this._cacheService,
    this._apiService,
    this._backgroundTaskService,
  ) : super(PrayerTimesInitial()) {
    on<FetchPrayerTimes>(_onFetchPrayerTimes);
    on<RefreshPrayerTimesIfDayChanged>(_onRefreshPrayerTimesIfDayChanged);
    on<RefreshPrayerTimes>(_onRefreshPrayerTimes);
  }

  Future<void> _onFetchPrayerTimes(
      FetchPrayerTimes event, Emitter<PrayerTimesState> emit) async {
    await _refresh(event.deviceState, emit: emit);
  }

  Future<void> _onRefreshPrayerTimes(
    RefreshPrayerTimes event,
    Emitter<PrayerTimesState> emit,
  ) async {
    if (!event.force && !_shouldRefreshForToday()) {
      return;
    }

    await _refresh(
      event.deviceState,
      emit: emit,
      force: event.force,
      skipStateGuard: true,
    );
  }

  Future<void> _refresh(
    DeviceStateResponse deviceState, {
    required Emitter<PrayerTimesState> emit,
    bool force = false,
    bool skipStateGuard = false,
  }) async {
    if (!skipStateGuard && state is PrayerTimesLoading) return;

    final snapshot = deviceState.toSnapshot();
    PrayerCacheEntry? localCache;
    Position? currentPosition;
    String? resolvedLocationName;
    _lastDeviceState = deviceState;

    try {
      // 1. Mevcut konumu al (veya varsayılan İstanbul)
      currentPosition = await _locationService.getCurrentLocation();

      // 2. Mevcut Geohash'i hesapla
      final String geohashValue =
          (_locationService.calculateGeohash(
        currentPosition.latitude,
        currentPosition.longitude,
      ) ?? '')
              .trim();
      final bool geohashFailed = geohashValue.isEmpty;

      // 3. Mevcut tarihi al
      final now = DateTime.now();
      final normalizedNow = _normalizeDate(now);
      final lastRecordedDay = _lastSuccessfulRefreshDay ??
          _normalizeDate(snapshot.cachedPrayerDate);
      if (!force && normalizedNow == lastRecordedDay) {
        return;
      }

      emit(PrayerTimesLoading());

      final currentDateKey = DateFormat('yyyy-MM-dd').format(now);

      // 4. "Karar Matrisi" - önce yerel cache'i, sonra backend cache'ini kontrol et
      if (!geohashFailed) {
        localCache = await _cacheService.readEntry(geohashValue, now);
        if (localCache != null) {
          resolvedLocationName = await _locationService.getPlacemark(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          _markRefreshDate(now);
          _markSuccessfulRefreshDay(now);
          emit(
            PrayerTimesSuccess(
              localCache.prayerTimes,
              resolvedLocationName,
              isFromCache: true,
            ),
          );
          return;
        }

        if (snapshot.hasCacheFor(now, geohashValue)) {
          resolvedLocationName = await _locationService.getPlacemark(
            currentPosition.latitude,
            currentPosition.longitude,
          );

          _markRefreshDate(now);
          _markSuccessfulRefreshDay(now);
          emit(
            PrayerTimesSuccess(
              snapshot.cachedPrayerTimes!,
              resolvedLocationName,
              isFromCache: true,
            ),
          );
          return;
        }
      }

      // CACHE MISS veya geohash hesaplanamadı → API çağrısı
      final request = PrayerTimesRequest(
        deviceId: deviceState.deviceIdString,
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

      if (!geohashFailed) {
        await _cacheService.writeEntry(
          geohash: geohashValue,
          date: now,
          prayerTimes: newPrayerTimes,
        );
      }

      final locationName = await _locationService.getPlacemark(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      resolvedLocationName = locationName;
      _markRefreshDate(now);
      _markSuccessfulRefreshDay(now);
      emit(
        PrayerTimesSuccess(
          newPrayerTimes,
          locationName,
          isFromCache: false,
          warning: geohashFailed
              ? 'Konum kodu oluşturulamadı, veriler doğrudan sunucudan getirildi.'
              : null,
        ),
      );
      return;
    } catch (e) {
      final fallbackPrayerTimes =
          localCache?.prayerTimes ?? snapshot.cachedPrayerTimes;

      if (fallbackPrayerTimes != null) {
        final fallbackLocation = resolvedLocationName ??
            await _resolveFallbackLocationName(
              currentPosition: currentPosition,
              snapshot: snapshot,
            );

        final now = DateTime.now();
        _markRefreshDate(now);
        _markSuccessfulRefreshDay(now);
        emit(
          PrayerTimesSuccess(
            fallbackPrayerTimes,
            fallbackLocation,
            isFromCache: true,
            warning:
                'Unable to refresh prayer times right now. Showing last known schedule.',
          ),
        );
      } else {
        emit(PrayerTimesFailure(e.toString()));
      }
    }
  }

  Future<String> _resolveFallbackLocationName({
    Position? currentPosition,
    required DeviceStateSnapshot snapshot,
  }) async {
    if (currentPosition != null) {
      return _locationService.getPlacemark(
        currentPosition.latitude,
        currentPosition.longitude,
      );
    }

    if (snapshot.hasLocation) {
      return _locationService.getPlacemark(
        snapshot.latitude!,
        snapshot.longitude!,
      );
    }

    return 'Last known location';
  }

  Future<void> _onRefreshPrayerTimesIfDayChanged(
    RefreshPrayerTimesIfDayChanged event,
    Emitter<PrayerTimesState> emit,
  ) async {
    if (state is PrayerTimesLoading) return;

    final candidateDeviceState = event.deviceState ?? _lastDeviceState;
    if (candidateDeviceState == null) return;

    final lastRefreshCandidate = _lastSuccessfulRefreshDay ??
        _normalizeDate(candidateDeviceState.deviceState?.lastPrayerDate);

    if (!_backgroundTaskService.hasDayChanged(
      lastRefreshCandidate,
      reference: event.referenceTime,
    )) {
      return;
    }

    add(FetchPrayerTimes(candidateDeviceState));
  }

  bool _shouldRefreshForToday() {
    final today = _normalizeDate(DateTime.now());
    if (today == null) return true;
    if (_lastSuccessfulRefreshDay == null) return true;
    return today != _lastSuccessfulRefreshDay;
  }

  void _markRefreshDate(DateTime timestamp) {
    _lastRefreshDate = _normalizeDate(timestamp);
  }

  void _markSuccessfulRefreshDay(DateTime timestamp) {
    _lastSuccessfulRefreshDay = _normalizeDate(timestamp);
  }

  DateTime? _normalizeDate(DateTime? input) {
    if (input == null) return null;
    return DateTime(input.year, input.month, input.day);
  }
}
