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
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final double heading = snapshot.data?.heading ?? _lastHeading ?? 0;
        _lastHeading = heading;

        final double rotationDeg = (widget.bearing - heading) % 360;
        final double rotationRad = rotationDeg * math.pi / 180;

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
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF243344),
                      Color(0xFF172130),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.surfaceHigh.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 28,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: _CompassTickPainter(),
                ),
              ),
              ..._cardinalLabels(context),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceHigh.withValues(alpha: 0.4),
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
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    SvgPicture.asset(
                      'assets/images/qibla_icon.svg',
                      width: 56,
                      height: 47,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
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
                    color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Text(
                      'Cihazınızı düz tutun ve pusula sensörünü etkinleştirin.',
                      style: TextStyle(color: AppColors.white),
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

List<Widget> _cardinalLabels(BuildContext context) {
  final TextStyle baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
      );

  return [
    // North - top center
    Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Text('N', style: baseStyle.copyWith(color: Colors.redAccent)),
      ),
    ),
    // South - bottom center
    Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Center(
        child: Text('S', style: baseStyle.copyWith(color: Colors.white70)),
      ),
    ),
    // West - left center
    Positioned(
      left: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Text('W', style: baseStyle.copyWith(color: Colors.white70)),
      ),
    ),
    // East - right center
    Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: Text('E', style: baseStyle.copyWith(color: Colors.white70)),
      ),
    ),
  ];
}

class _CompassTickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final Paint majorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Paint minorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
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
