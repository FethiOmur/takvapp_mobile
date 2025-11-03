import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/app_init/cubit/app_init_cubit.dart';
import 'package:takvapp_mobile/features/home/view/home_screen.dart';

class AppInitWrapperPage extends StatelessWidget {
  const AppInitWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppInitCubit, AppInitState>(
      builder: (context, state) {
        if (state is AppInitSuccess) {
          return HomeScreen(deviceState: state.deviceState);
        }

        if (state is AppInitFailure) {
          return _StatusScaffold(
            icon: Icons.wifi_off,
            title: 'Bağlantı sorunu',
            message:
                'Takva ile bağlantı kurulamadı. Lütfen internetinizi kontrol edip tekrar deneyin.',
            primaryLabel: 'Tekrar dene',
            onPrimaryTap: () =>
                context.read<AppInitCubit>().initializeApp(),
          );
        }

        return const _StatusScaffold(
          icon: Icons.brightness_low_outlined,
          title: 'Hazırlanıyor...',
          message: 'Namaz vakitlerinizi kişiselleştiriyoruz. Lütfen birkaç saniye bekleyin.',
          showSpinner: true,
        );
      },
    );
  }
}

class _StatusScaffold extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final bool showSpinner;
  final String? primaryLabel;
  final VoidCallback? onPrimaryTap;

  const _StatusScaffold({
    required this.icon,
    required this.title,
    required this.message,
    this.showSpinner = false,
    this.primaryLabel,
    this.onPrimaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.surfaceLow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white.withAlpha(30)),
                  ),
                  child: Icon(icon, size: 48, color: AppColors.secondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(title, style: AppTextStyles.displayL, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                Text(
                  message,
                  style: AppTextStyles.bodyM,
                  textAlign: TextAlign.center,
                ),
                if (showSpinner) ...[
                  const SizedBox(height: AppSpacing.xl),
                  const _Spinner(),
                ],
                if (primaryLabel != null && onPrimaryTap != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPrimaryTap,
                      child: Text(primaryLabel!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _SpinnerPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double progress;

  _SpinnerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final rect = Offset.zero & size;
    const startAngle = -90.0 * (3.1415926 / 180.0);
    final sweepAngle = progress * 2 * 3.1415926;

    final backgroundPaint = Paint()
      ..color = AppColors.surfaceHigh.withAlpha(60)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryVariant, AppColors.primary],
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2),
      0,
      2 * 3.1415926,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: rect.center, radius: size.width / 2),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
