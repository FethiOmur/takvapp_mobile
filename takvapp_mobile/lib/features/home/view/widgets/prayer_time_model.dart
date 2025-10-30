class PrayerTime {
  final String name;
  final String time;
  final String iconUrl;
  final bool isCurrent;

  PrayerTime({
    required this.name,
    required this.time,
    required this.iconUrl,
    this.isCurrent = false,
  });
}
