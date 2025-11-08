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
                        AppColors.surfaceHigh.withValues(alpha: 0.6),
                        AppColors.surface.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.04)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 32,
                        spreadRadius: -2,
                        offset: const Offset(0, 0),
                      ),
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      color: AppColors.surfaceHigh.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.1),
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
                            color: AppColors.white,
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
                        Text('Ask Imam AI', style: AppTextStyles.headingM),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Get instant answers to fiqh questions and daily dilemmas with trusted sources.',
                          style: AppTextStyles.bodyS,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryVariant,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    child: const Text('Open'),
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
