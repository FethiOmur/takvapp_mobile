import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
              Positioned.fill(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Icon(
                      Icons.navigation_rounded,
                      size: 120,
                      color: const Color(0xFFF6E05E),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E05E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: const Color(0xFFF6E05E).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Kıble',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFF6E05E),
                              fontWeight: FontWeight.w600,
                            ),
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
    Positioned(
      top: AppSpacing.sm,
      child: Text('N', style: baseStyle.copyWith(color: Colors.redAccent)),
    ),
    Positioned(
      bottom: AppSpacing.sm,
      child: Text('S', style: baseStyle.copyWith(color: Colors.white70)),
    ),
    Positioned(
      left: AppSpacing.sm,
      child: Text('W', style: baseStyle.copyWith(color: Colors.white70)),
    ),
    Positioned(
      right: AppSpacing.sm,
      child: Text('E', style: baseStyle.copyWith(color: Colors.white70)),
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
      ..strokeWidth = 3;

    final Paint minorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.5;

    for (int degree = 0; degree < 360; degree += 5) {
      final double angleRad = degree * math.pi / 180;
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
