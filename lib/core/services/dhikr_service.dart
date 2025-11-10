import 'package:shared_preferences/shared_preferences.dart';

class DhikrService {
  static const String _dhikrListKey = 'recited_dhikrs';
  static const String _totalCountKey = 'total_dhikr_count';

  /// Çekilen zikirleri kaydet
  static Future<void> saveRecitedDhikr(String turkishName) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_dhikrListKey) ?? [];
    
    // Eğer zaten listede yoksa ekle
    if (!currentList.contains(turkishName)) {
      currentList.add(turkishName);
      await prefs.setStringList(_dhikrListKey, currentList);
    }
  }

  /// Çekilen zikirleri getir
  static Future<List<String>> getRecitedDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_dhikrListKey) ?? [];
  }

  /// Toplam zikir sayısını artır
  static Future<void> incrementTotalCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_totalCountKey) ?? 0;
    await prefs.setInt(_totalCountKey, currentCount + 1);
  }

  /// Toplam zikir sayısını getir
  static Future<int> getTotalCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCountKey) ?? 0;
  }

  /// Toplam zikir sayısını sıfırla
  static Future<void> resetTotalCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalCountKey, 0);
  }

  /// Tüm çekilen zikirleri temizle
  static Future<void> clearRecitedDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dhikrListKey);
  }
}

