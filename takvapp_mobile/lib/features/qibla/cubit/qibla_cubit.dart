import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:takvapp_mobile/core/models/device_state_response_model.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';

part 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit(this._locationService) : super(const QiblaState());

  final LocationService _locationService;

  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  Future<void> loadQibla({Location? fallbackLocation}) async {
    emit(state.copyWith(status: QiblaStatus.loading, errorMessage: null));

    try {
      final Position currentPosition = await _locationService.getCurrentLocation();
      await _emitSuccess(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        usedFallback: false,
      );
    } catch (_) {
      if (fallbackLocation != null) {
        await _emitSuccess(
          latitude: fallbackLocation.latitude,
          longitude: fallbackLocation.longitude,
          usedFallback: true,
        );
      } else {
        emit(state.copyWith(
          status: QiblaStatus.failure,
          errorMessage:
              'Konum bilgisine erişilemedi. Lütfen konum izinlerini kontrol edin.',
        ));
      }
    }
  }

  Future<void> _emitSuccess({
    required double latitude,
    required double longitude,
    required bool usedFallback,
  }) async {
    final double bearing = _calculateBearing(latitude, longitude);
    final double distanceKm = _calculateDistanceKm(latitude, longitude);
    final String locationName = await _locationService.getPlacemark(latitude, longitude);
    final String directionLabel = _bearingToCardinal(bearing);

    emit(state.copyWith(
      status: QiblaStatus.success,
      userLatitude: latitude,
      userLongitude: longitude,
      qiblaBearing: bearing,
      qiblaDirectionLabel: directionLabel,
      distanceToKaabaKm: distanceKm,
      locationDescription: locationName,
      usedFallbackPosition: usedFallback,
    ));
  }

  double _calculateBearing(double latitude, double longitude) {
    final double userLatRad = _degreesToRadians(latitude);
    final double userLonRad = _degreesToRadians(longitude);
    final double kaabaLatRad = _degreesToRadians(_kaabaLatitude);
    final double kaabaLonRad = _degreesToRadians(_kaabaLongitude);
    final double deltaLon = kaabaLonRad - userLonRad;

    final double y = sin(deltaLon) * cos(kaabaLatRad);
    final double x = cos(userLatRad) * sin(kaabaLatRad) -
        sin(userLatRad) * cos(kaabaLatRad) * cos(deltaLon);

    final double bearingRad = atan2(y, x);
    final double bearingDeg = (_radiansToDegrees(bearingRad) + 360) % 360;
    return bearingDeg;
  }

  double _calculateDistanceKm(double latitude, double longitude) {
    const double earthRadiusKm = 6371.0;
    final double userLatRad = _degreesToRadians(latitude);
    final double userLonRad = _degreesToRadians(longitude);
    final double kaabaLatRad = _degreesToRadians(_kaabaLatitude);
    final double kaabaLonRad = _degreesToRadians(_kaabaLongitude);

    final double deltaLat = kaabaLatRad - userLatRad;
    final double deltaLon = kaabaLonRad - userLonRad;

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(userLatRad) * cos(kaabaLatRad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  String _bearingToCardinal(double bearing) {
    const List<String> directions = [
      'Kuzey',
      'Kuzeydoğu',
      'Doğu',
      'Güneydoğu',
      'Güney',
      'Güneybatı',
      'Batı',
      'Kuzeybatı',
    ];
    final int index = ((bearing + 22.5) % 360 ~/ 45) % directions.length;
    return directions[index];
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;

  double _radiansToDegrees(double radians) => radians * 180 / pi;
}
