import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class AskImamCard extends StatefulWidget {
  const AskImamCard({super.key});

  @override
  State<AskImamCard> createState() => _AskImamCardState();
}

class _AskImamCardState extends State<AskImamCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor1 = isDark 
        ? AppColors.surfaceHigh.withValues(alpha: 0.6)
        : AppColors.lightSurface.withValues(alpha: 0.9);
    final cardBgColor2 = isDark 
        ? AppColors.surface.withValues(alpha: 0.5)
        : AppColors.lightSurfaceHigh.withValues(alpha: 0.95);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cardBgColor1,
                        cardBgColor2,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isDark) ...[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: SvgPicture.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppColors.white.withValues(alpha: 0.07),
                      BlendMode.srcATop,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(color: AppColors.white.withValues(alpha: 0.01)),
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.white.withValues(alpha: 0.04),
                          AppColors.transparent,
                        ],
                        stops: const [0, 0.55],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.04)
                          : AppColors.lightTextMuted.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.25)
                            : AppColors.white.withValues(alpha: 0.15),
                        blurRadius: 32,
                        spreadRadius: -2,
                        offset: const Offset(0, 0),
                      ),
                      BoxShadow(
                        color: isDark
                            ? AppColors.secondary.withValues(alpha: 0.15)
                            : AppColors.white.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isDark)
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(_shimmerAnimation.value - 1, -1),
                            end: Alignment(_shimmerAnimation.value + 1, 1),
                            colors: [
                              Colors.transparent,
                              AppColors.white.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceHigh.withValues(alpha: 0.4)
                          : AppColors.lightSurfaceHigh.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.1)
                            : AppColors.lightTextMuted.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * 3.14159,
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 28,
                            color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İmam AI\'ya Sor',
                          style: AppTextStyles.headingM.copyWith(
                            color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Güvenilir kaynaklarla fıkıh sorularına ve günlük ikilemlere anında cevaplar alın.',
                          style: AppTextStyles.bodyS.copyWith(
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4D8DFF),
                          Color(0xFF62F5FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF62F5FF).withValues(alpha: 0.16),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Aç',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
