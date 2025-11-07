
import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Varsayılan İstanbul konumu (Senaryo 2: HAYIR)
  final _defaultPosition = Position(
    latitude: 41.0082,
    longitude: 28.9784,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  String? calculateGeohash(double lat, double lon) {
    try {
      return GeoHasher().encode(lat, lon, precision: 6);
    } catch (_) {
      return null;
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return _defaultPosition;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _defaultPosition;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return _defaultPosition;
    }

    if (Platform.isIOS) {
      final accuracyStatus = await Geolocator.getLocationAccuracy();
      if (accuracyStatus == LocationAccuracyStatus.reduced) {
        try {
          await Geolocator.requestTemporaryFullAccuracy(purposeKey: 'PrayerTimesPrecision');
        } catch (_) {
          // Kullanıcı reddederse mevcut doğrulukla devam edilir.
        }
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
        ),
      ).timeout(const Duration(seconds: 8));
      return position;
    } on TimeoutException {
      final fallback = await Geolocator.getLastKnownPosition();
      return fallback ?? _defaultPosition;
    } catch (_) {
      final fallback = await Geolocator.getLastKnownPosition();
      return fallback ?? _defaultPosition;
    }
  }

  Future<String> getPlacemark(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 5));
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.locality}, ${placemark.country}";
      }
      return "Unknown Location";
    } catch (e) {
      return "Unknown Location";
    }
  }
}
