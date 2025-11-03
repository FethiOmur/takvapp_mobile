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
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              'Kıble Bulucu',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingM.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _HeaderIconButton(
            icon: Icons.info_outline_rounded,
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Kıble hakkında'),
        content: const Text(
          'Namaz kılarken yöneldiğimiz kıble, Mekke’deki Kâbe’yi gösterir. '
          'Cihazınızın pusulası ve konum servisleri yardımıyla bu yön hesaplanır.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          foregroundColor: AppColors.textPrimary,
        ),
        onPressed: onPressed,
        child: Icon(icon),
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
                if (state.usedFallbackPosition) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const _FallbackNotice(),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
        const SizedBox(height: AppSpacing.sm),
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

class _QiblaDirectionHint extends StatelessWidget {
  const _QiblaDirectionHint({required this.bearing});

  final double bearing;

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

        final double delta = ((bearing - heading) + 360) % 360;
        final bool turnLeft = delta > 180;
        final double adjustment = turnLeft ? 360 - delta : delta;
        final String hint = turnLeft ? 'Sola' : 'Sağa';

        return Column(
          children: [
            Text(
              '$hint ${adjustment.toStringAsFixed(0)}° dön',
              style: AppTextStyles.displayL.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
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
