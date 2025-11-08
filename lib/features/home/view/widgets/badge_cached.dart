import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class BadgeCached extends StatelessWidget {
  const BadgeCached({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        'Cached',
        style: AppTextStyles.label.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}

