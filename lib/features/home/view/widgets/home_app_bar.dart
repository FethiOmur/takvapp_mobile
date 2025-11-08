import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final clock = DateFormat('HH:mm').format(DateTime.now());
    final dateLabel = DateFormat('EEEE, d MMMM', 'en_US').format(DateTime.now());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(clock, style: AppTextStyles.bodyS.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('Selamün Aleyküm', style: AppTextStyles.bodyS),
            Text(dateLabel, style: AppTextStyles.bodyS),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.white.withAlpha(24)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.notifications_active_outlined, color: AppColors.secondary),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            ],
          ),
        ),
      ],
    );
  }
}
