enum PrayerKey {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  String get displayName {
    switch (this) {
      case PrayerKey.fajr:
        return 'Fajr';
      case PrayerKey.sunrise:
        return 'Sunrise';
      case PrayerKey.dhuhr:
        return 'Dhuhr';
      case PrayerKey.asr:
        return 'Asr';
      case PrayerKey.maghrib:
        return 'Maghrib';
      case PrayerKey.isha:
        return 'Isha';
    }
  }
}

class PrayerTimesCardModel {
  final String city;
  final String? country;
  final bool isCached;
  final Map<PrayerKey, DateTime> times;
  final DateTime now;
  final PrayerKey selected;
  final PrayerKey nextPrayer;

  const PrayerTimesCardModel({
    required this.city,
    this.country,
    required this.isCached,
    required this.times,
    required this.now,
    required this.selected,
    required this.nextPrayer,
  });

  DateTime? getTime(PrayerKey key) => times[key];
  String? getTimeString(PrayerKey key) {
    final time = times[key];
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Duration getCountdown() {
    final nextTime = times[nextPrayer];
    if (nextTime == null) return Duration.zero;
    
    var targetTime = DateTime(now.year, now.month, now.day, nextTime.hour, nextTime.minute);
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }
    return targetTime.difference(now);
  }
}

