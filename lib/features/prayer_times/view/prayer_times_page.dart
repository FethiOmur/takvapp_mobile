import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/api/fake_api_service.dart';
import 'package:takvapp_mobile/core/models/monthly_prayer_times_model.dart';
import 'package:takvapp_mobile/core/services/location_service.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:geocoding/geocoding.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  final FakeApiService _apiService = FakeApiService();
  MonthlyPrayerTimes? _monthlyData;
  bool _isLoading = true;
  String _locationName = 'Yükleniyor...';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyData();
    });
  }

  Future<void> _loadMonthlyData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      String placemark = 'Bilinmeyen Konum';
      
      try {
        final locationService = context.read<LocationService>();
        final position = await locationService.getCurrentLocation().timeout(
          const Duration(seconds: 10),
        );
        
        try {
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(
            const Duration(seconds: 5),
            onTimeout: () => <Placemark>[],
          );

          if (placemarks.isNotEmpty) {
            final pm = placemarks.first;
            final city = pm.locality ?? pm.subAdministrativeArea ?? '';
            final country = pm.country ?? '';
            placemark = city.isNotEmpty 
                ? '$city, $country'
                : country.isNotEmpty 
                    ? country 
                    : 'Bilinmeyen Konum';
          } else {
            placemark = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
          }
        } catch (e) {
          // Placemark alınamazsa koordinatları kullan
          placemark = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
        }
      } catch (e) {
        // Location alınamazsa varsayılan konum kullan
        placemark = 'Istanbul, Turkey';
      }

      if (!mounted) return;
      final data = await _apiService.getMonthlyPrayerTimes(
        location: placemark,
        year: _selectedDate.year,
        month: _selectedDate.month,
      );
      if (!mounted) return;
      setState(() {
        _monthlyData = data;
        _locationName = placemark;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // Hata durumunda bile mock data göster
      try {
        final data = await _apiService.getMonthlyPrayerTimes(
          location: 'Istanbul, Turkey',
          year: _selectedDate.year,
          month: _selectedDate.month,
        );
        if (!mounted) return;
        setState(() {
          _monthlyData = data;
          _locationName = 'Istanbul, Turkey';
          _isLoading = false;
        });
      } catch (e2) {
        if (!mounted) return;
        setState(() {
          _locationName = 'Bilinmeyen Konum';
          _isLoading = false;
        });
      }
    }
  }

  String _getMonthName(int month) {
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }

  String _getTitleText() {
    if (_locationName.isEmpty || 
        _locationName == 'Yükleniyor...' || 
        _locationName == 'Bilinmeyen Konum') {
      return 'Namaz Vakitleri';
    }
    return '$_locationName için ${_getMonthName(_selectedDate.month)} ${_selectedDate.year} Namaz Vakitleri';
  }

  static String _getWeekdayTurkish(String weekday) {
    const weekdays = {
      'Mo': 'Pzt',
      'Tu': 'Sal',
      'We': 'Çar',
      'Th': 'Per',
      'Fr': 'Cum',
      'Sa': 'Cmt',
      'Su': 'Paz',
    };
    return weekdays[weekday] ?? weekday;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.getBackgroundGradient(context),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _getTitleText(),
                    style: AppTextStyles.displayL.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (_locationName != 'Yükleniyor...' && _locationName != 'Bilinmeyen Konum') ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _locationName,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Table
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _monthlyData == null
                      ? Center(
                          child: Text(
                            'Veri bulunamadı',
                            style: AppTextStyles.bodyM.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        )
                      : _PrayerTimesTable(
                          monthlyData: _monthlyData!,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerTimesTable extends StatelessWidget {
  final MonthlyPrayerTimes monthlyData;

  const _PrayerTimesTable({
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: MediaQuery.of(context).padding.bottom + 120,
      ),
      child: Column(
        children: [
          // Table header
          _TableHeader(),
          const SizedBox(height: AppSpacing.md),
          // Table rows
          ...monthlyData.dailyTimes.map((day) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _TableRow(day: day),
              )),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceHigh.withValues(alpha: 0.3)
            : AppColors.lightSurfaceHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _HeaderCell(
              icon: Icons.calendar_today_rounded,
              label: 'Gün',
            ),
          ),
          Expanded(
            flex: 2,
            child: _HeaderCell(
              icon: Icons.cloud_rounded,
              label: 'Sabah',
            ),
          ),
          Expanded(
            flex: 2,
            child: _HeaderCell(
              icon: Icons.wb_twilight_rounded,
              label: 'Güneş',
            ),
          ),
          Expanded(
            flex: 2,
            child: _HeaderCell(
              icon: Icons.wb_sunny_rounded,
              label: 'Öğle',
            ),
          ),
          Expanded(
            flex: 2,
            child: _HeaderCell(
              icon: Icons.cloud_rounded,
              label: 'İkindi',
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderCell({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.textSecondary : AppColors.lightTextPrimary;
    final textColor = isDark ? AppColors.textSecondary : AppColors.lightTextPrimary;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodyS.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TableRow extends StatelessWidget {
  final DailyPrayerTime day;

  const _TableRow({required this.day});

  String _formatTime(String? time) {
    if (time == null) return '--:--';
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isToday = day.day == DateTime.now().day &&
        DateTime.now().month == DateTime.now().month;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.15)
            : (isDark
                ? AppColors.surfaceHigh.withValues(alpha: 0.2)
                : AppColors.lightSurfaceHigh.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isToday
            ? Border.all(
                color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.4),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _DataCell(
              text: '${day.day.toString().padLeft(2, '0')}, ${_PrayerTimesPageState._getWeekdayTurkish(day.weekday)}',
              isBold: isToday,
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              text: _formatTime(day.times.fajr),
              isBold: isToday,
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              text: _formatTime(day.times.sunrise),
              isBold: isToday,
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              text: _formatTime(day.times.dhuhr),
              isBold: isToday,
            ),
          ),
          Expanded(
            flex: 2,
            child: _DataCell(
              text: _formatTime(day.times.asr),
              isBold: isToday,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final bool isBold;

  const _DataCell({
    required this.text,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isBold
        ? (isDark ? AppColors.white : AppColors.lightTextPrimary)
        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary);
    
    return Text(
      text,
      style: AppTextStyles.bodyM.copyWith(
        color: textColor,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }
}

