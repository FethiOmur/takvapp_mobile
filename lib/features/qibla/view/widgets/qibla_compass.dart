import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key, required this.bearing});

  final double bearing;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? _lastHeading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final double heading = snapshot.data?.heading ?? _lastHeading ?? 0;
        _lastHeading = heading;

        final double rotationDeg = (widget.bearing - heading) % 360;
        final double rotationRad = rotationDeg * math.pi / 180;
        
        // Kabe tam karşıya geldiğinde (±2 derece tolerans)
        final double adjustment = rotationDeg > 180 ? 360 - rotationDeg : rotationDeg;
        final bool isAligned = adjustment <= 2.0;
        final Color kaabaColor = isAligned ? const Color(0xFFFFD27D) : (isDark ? AppColors.white : AppColors.lightTextPrimary);
        final Color arrowColor = isAligned ? const Color(0xFFFFD27D) : (isDark ? AppColors.white : AppColors.lightTextPrimary);

        return SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF243344),
                            const Color(0xFF172130),
                          ]
                        : [
                            AppColors.lightSurfaceHigh,
                            AppColors.lightSurface,
                          ],
                  ),
                  border: Border.all(
                    color: isDark
                        ? AppColors.surfaceHigh.withValues(alpha: 0.6)
                        : AppColors.lightTextMuted.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : Colors.black12,
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: _CompassTickPainter(isDark: isDark),
                ),
              ),
              ..._cardinalLabels(context, isDark),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.background.withValues(alpha: 0.55)
                      : AppColors.lightSurfaceLow.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.surfaceHigh.withValues(alpha: 0.4)
                        : AppColors.lightTextMuted.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
              ),
              Transform.rotate(
                angle: rotationRad,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      size: 110,
                      color: arrowColor,
                    ),
                    const SizedBox(height: 8),
                    SvgPicture.asset(
                      'assets/images/qibla_icon.svg',
                      width: 56,
                      height: 47,
                      colorFilter: ColorFilter.mode(
                        kaabaColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_hasHeading(snapshot))
                Positioned(
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.45)
                          : AppColors.lightTextPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Text(
                      'Cihazınızı düz tutun ve pusula sensörünü etkinleştirin.',
                      style: TextStyle(
                        color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  bool _hasHeading(AsyncSnapshot<CompassEvent> snapshot) {
    final event = snapshot.data;
    if (event == null) return false;
    return event.heading != null;
  }
}

List<Widget> _cardinalLabels(BuildContext context, bool isDark) {
  final TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
      );
  final labelColor = isDark ? Colors.white70 : AppColors.lightTextMuted;

  return [
    // North - top center
    Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'N',
          style: baseStyle.copyWith(
            color: isDark ? Colors.redAccent : AppColors.error,
          ),
        ),
      ),
    ),
    // South - bottom center
    Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Text('S', style: baseStyle.copyWith(color: labelColor)),
      ),
    ),
    // West - left center
    Positioned(
      left: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Text('W', style: baseStyle.copyWith(color: labelColor)),
      ),
    ),
    // East - right center
    Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Text('E', style: baseStyle.copyWith(color: labelColor)),
      ),
    ),
  ];
}

class _CompassTickPainter extends CustomPainter {
  final bool isDark;

  _CompassTickPainter({this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final tickColor = isDark ? Colors.white : AppColors.lightTextPrimary;

    final Paint majorTickPaint = Paint()
      ..color = tickColor.withValues(alpha: 0.24)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Paint minorTickPaint = Paint()
      ..color = tickColor.withValues(alpha: 0.12)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Start from -90 degrees so North (0°) is at the top
    for (int degree = 0; degree < 360; degree += 5) {
      final double angleRad = (degree - 90) * math.pi / 180;
      final double innerRadius = degree % 30 == 0 ? radius - 20 : radius - 10;

      final Offset start = Offset(
        center.dx + radius * math.cos(angleRad),
        center.dy + radius * math.sin(angleRad),
      );
      final Offset end = Offset(
        center.dx + innerRadius * math.cos(angleRad),
        center.dy + innerRadius * math.sin(angleRad),
      );

      canvas.drawLine(
        start,
        end,
        degree % 30 == 0 ? majorTickPaint : minorTickPaint,
      );
    }

    final Paint focusRing = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius - 6, focusRing);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
