import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/qibla/cubit/qibla_cubit.dart';
import 'package:takvapp_mobile/features/qibla/view/widgets/qibla_compass.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<QiblaCubit, QiblaState>(
        builder: (context, state) {
          return Column(
            children: [
              const _QiblaHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, QiblaState state) {
    switch (state.status) {
      case QiblaStatus.initial:
      case QiblaStatus.loading:
        return const _QiblaLoading();
      case QiblaStatus.failure:
        return _QiblaError(
          message: state.errorMessage ?? 'Bir sorun oluştu. Lütfen tekrar deneyin.',
        );
      case QiblaStatus.success:
        if (state.qiblaBearing == null || state.distanceToKaabaKm == null) {
          return const _QiblaError(message: 'Kıble yönü hesaplanamadı.');
        }
        return _QiblaSuccessView(state: state);
    }
  }
}

class _QiblaHeader extends StatelessWidget {
  const _QiblaHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.lg,
        bottom: AppSpacing.md,
      ),
      child: Center(
        child: Text(
          'Kıble Bulucu',
          textAlign: TextAlign.center,
          style: AppTextStyles.headingM.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QiblaInfoText extends StatelessWidget {
  const _QiblaInfoText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(
        'Namaz kılarken yöneldiğimiz kıble, Mekke\'deki Kâbe\'yi gösterir. '
        'Cihazınızın pusulası ve konum servisleri yardımıyla bu yön hesaplanır.',
        style: AppTextStyles.bodyM.copyWith(
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _QiblaLoading extends StatelessWidget {
  const _QiblaLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _QiblaError extends StatelessWidget {
  const _QiblaError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: AppTextStyles.bodyM.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => context.read<QiblaCubit>().loadQibla(),
            child: const Text('Tekrar dene'),
          ),
        ],
      ),
    );
  }
}

class _QiblaSuccessView extends StatelessWidget {
  const _QiblaSuccessView({required this.state});

  final QiblaState state;

  @override
  Widget build(BuildContext context) {
    final double bearing = state.qiblaBearing!;
    final String bearingLabel = '${bearing.toStringAsFixed(0)}°';
    final String locationDescription = state.locationDescription ?? 'Bilinmeyen Konum';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: QiblaCompass(bearing: bearing),
                ),
                const SizedBox(height: AppSpacing.xl),
                _QiblaDirectionHint(bearing: bearing),
                const SizedBox(height: AppSpacing.md),
                _QiblaStatsRow(
                  bearingLabel: bearingLabel,
                  directionLabel: state.qiblaDirectionLabel,
                  distanceKm: state.distanceToKaabaKm,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _QiblaInfoText(),
                if (state.usedFallbackPosition) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const _FallbackNotice(),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg + 80,
          ),
          child: Column(
            children: [
              Text(
                locationDescription,
                style: AppTextStyles.bodyL.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FallbackNotice extends StatelessWidget {
  const _FallbackNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Konum servislerine ulaşılamadığı için en son bilinen konum kullanılıyor.',
              style: AppTextStyles.bodyS.copyWith(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _QiblaDirectionHint extends StatefulWidget {
  const _QiblaDirectionHint({required this.bearing});

  final double bearing;

  @override
  State<_QiblaDirectionHint> createState() => _QiblaDirectionHintState();
}

class _QiblaDirectionHintState extends State<_QiblaDirectionHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _wasAligned = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        if (heading == null) {
          return Text(
            'Cihazı düz tutarak ok Kıbleyi gösterene kadar çevirin.',
            style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          );
        }

        final double delta = ((widget.bearing - heading) + 360) % 360;
        final bool turnLeft = delta > 180;
        final double adjustment = turnLeft ? 360 - delta : delta;
        final String hint = turnLeft ? 'Sola' : 'Sağa';
        
        // Kabe tam karşıya geldiğinde (±2 derece tolerans)
        final bool isAligned = adjustment <= 2.0;
        
        // İlk kez hizalandığında animasyonu başlat
        if (isAligned && !_wasAligned) {
          _wasAligned = true;
          _controller.forward();
        } else if (!isAligned && _wasAligned) {
          _wasAligned = false;
          _controller.reset();
        }

        if (isAligned) {
          return SizedBox(
            height: 80 + (AppSpacing.lg * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFD27D).withValues(alpha: 0.2),
                            border: Border.all(
                              color: const Color(0xFFFFD27D),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFFFFD27D),
                            size: 50,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 80 + (AppSpacing.lg * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$hint dön',
                style: AppTextStyles.displayL.copyWith(
                  fontSize: 24,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QiblaStatsRow extends StatelessWidget {
  const _QiblaStatsRow({
    required this.bearingLabel,
    required this.directionLabel,
    required this.distanceKm,
  });

  final String bearingLabel;
  final String? directionLabel;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: [
        _Chip(text: 'Kıble: $bearingLabel'),
        if (directionLabel != null && directionLabel!.isNotEmpty)
          _Chip(text: directionLabel!),
        if (distanceKm != null)
          _Chip(text: '${distanceKm!.toStringAsFixed(0)} km'),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyS.copyWith(color: AppColors.white),
      ),
    );
  }
}
