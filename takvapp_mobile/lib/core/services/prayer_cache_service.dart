import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/prayer_cache_entry.dart';
import '../models/prayer_times_model.dart';

class PrayerCacheService {
  static const _cachePrefix = 'prayer_cache';

  Future<PrayerCacheEntry?> readEntry(String geohash, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey(geohash, date));
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final entry = PrayerCacheEntry.fromJson(decoded);
      if (!entry.isValidFor(date, geohash)) {
        await prefs.remove(_cacheKey(geohash, date));
        return null;
      }
      return entry;
    } catch (_) {
      await prefs.remove(_cacheKey(geohash, date));
      return null;
    }
  }

  Future<void> writeEntry({
    required String geohash,
    required DateTime date,
    required PrayerTimes prayerTimes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = PrayerCacheEntry(
      prayerTimes: prayerTimes,
      geohash6: geohash,
      cachedForDate: DateTime(date.year, date.month, date.day),
      storedAt: DateTime.now(),
    );

    await prefs.setString(
      _cacheKey(geohash, date),
      jsonEncode(entry.toJson()),
    );
  }

  Future<void> clearEntry(String geohash, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey(geohash, date));
  }

  String _cacheKey(String geohash, DateTime date) =>
      '$_cachePrefix:$geohash:${_formatDate(date)}';

  String _formatDate(DateTime date) =>
      DateTime(date.year, date.month, date.day).toIso8601String().split('T').first;
}
