
import 'package:geolocator/geolocator.dart';
import 'package:dart_geohash/dart_geohash.dart';

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

  String calculateGeohash(double lat, double lon) {
    var geoHasher = GeoHasher();
    return geoHasher.encode(lon, lat, precision: 6); // 6 karakter hassasiyet
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _defaultPosition;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return _defaultPosition;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return _defaultPosition;
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
    } catch (e) {
      return _defaultPosition;
    }
  }
}
