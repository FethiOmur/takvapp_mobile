import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/services/dhikr_service.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<String> _recitedDhikrs = [];
  int _totalDhikrCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dhikrs = await DhikrService.getRecitedDhikrs();
    final totalCount = await DhikrService.getTotalCount();
    setState(() {
      _recitedDhikrs = dhikrs;
      _totalDhikrCount = totalCount;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her göründüğünde verileri yeniden yükle
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.getBackgroundGradient(context),
          ),
        ),
        child: SafeArea(
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.surfaceHigh.withValues(alpha: 0.3)
                              : AppColors.lightSurfaceHigh.withValues(alpha: 0.3),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İstatistikler',
                            style: AppTextStyles.displayL.copyWith(
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                'Bu ay',
                                style: AppTextStyles.bodyM.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kuran Okuma Kartı
                      _LargeStatCard(
                        title: 'Kuran Okuma',
                        value: '463',
                        unit: 'sayfa',
                        chartData: [10, 25, 30, 45, 50, 60, 70, 65, 80, 75, 90, 95],
                        chartLabels: ['1', '6', '11', '16', '21', '30'],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // İki küçük kart
                      Row(
                        children: [
                          Expanded(
                            child: _SmallStatCard(
                              title: 'Hatim',
                              value: '3',
                              unit: 'kez',
                              barData: [0.6, 0.8, 0.5, 0.7, 0.9],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _SmallStatCard(
                              title: 'Namaz',
                              value: '460',
                              unit: 'kez',
                              barData: [0.7, 0.9, 0.6, 0.8, 0.95],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Overview Section
                      Builder(
                        builder: (context) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          return Text(
                            'Genel Bakış',
                            style: AppTextStyles.displayL.copyWith(
                              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Toplam Zikir Kartı
                      _TotalStatCard(
                        title: 'Toplam Zikir',
                        value: _totalDhikrCount.toString(),
                        unit: 'kez',
                        assetLabel: 'Zikir',
                        progress: 0.95,
                        dhikrList: _recitedDhikrs,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final List<double> chartData;
  final List<String> chartLabels;

  const _LargeStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.chartData,
    required this.chartLabels,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1F2E)
            : AppColors.lightSurface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.06)
              : AppColors.lightTextMuted.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.displayXL.copyWith(
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: AppTextStyles.bodyM.copyWith(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 80,
            child: _LineChart(
              data: chartData,
              labels: chartLabels,
              color: isDark
                  ? AppColors.textSecondary.withValues(alpha: 0.6)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final List<double> barData;

  const _SmallStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.barData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1F2E)
            : AppColors.lightSurface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.06)
              : AppColors.lightTextMuted.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.displayL.copyWith(
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: AppTextStyles.bodyS.copyWith(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 40,
            child: _BarChart(data: barData),
          ),
        ],
      ),
    );
  }
}

class _TotalStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String assetLabel;
  final double progress;
  final List<String> dhikrList;

  const _TotalStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.assetLabel,
    required this.progress,
    required this.dhikrList,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1F2E)
            : AppColors.lightSurface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.06)
              : AppColors.lightTextMuted.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.displayXL.copyWith(
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: AppTextStyles.bodyM.copyWith(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark
                  ? AppColors.surfaceHigh
                  : AppColors.lightSurfaceHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.4)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.textSecondary.withValues(alpha: 0.4)
                      : AppColors.lightTextSecondary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                assetLabel,
                style: AppTextStyles.bodyS.copyWith(
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Zikir listesi - İki sütunlu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sol sütun
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dhikrList
                      .where((dhikr) => dhikrList.indexOf(dhikr) % 2 == 0)
                      .map((dhikr) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    dhikr,
                                    style: AppTextStyles.bodyS.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Sağ sütun
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dhikrList
                      .where((dhikr) => dhikrList.indexOf(dhikr) % 2 == 1)
                      .map((dhikr) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    dhikr,
                                    style: AppTextStyles.bodyS.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;

  const _LineChart({
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        labels: labels,
        color: color,
        maxValue: maxValue,
        minValue: minValue,
        range: range,
      ),
      child: Container(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final double maxValue;
  final double minValue;
  final double range;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.maxValue,
    required this.minValue,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    final stepY = size.height / (range > 0 ? range : 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = data[i] - minValue;
      final y = size.height - (normalizedValue * stepY);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Highlight point at index 2 (day 11)
      if (i == 2) {
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChart extends StatelessWidget {
  final List<double> data;

  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((value) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              height: 40 * value,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

