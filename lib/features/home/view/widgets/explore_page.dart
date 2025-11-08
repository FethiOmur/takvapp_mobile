import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0F14),
            Color(0xFF101A22),
            Color(0xFF1C262E),
            AppColors.surfaceLow,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keşfet',
                      style: AppTextStyles.displayL.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'İslami içerik ve özellikler',
                      style: AppTextStyles.bodyM.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _FeatureCard(
                    icon: Icons.mosque_rounded,
                    title: 'Camiler',
                    description: 'Etrafınızdaki camii ve helal tüm yerleri kolaylıkla görüntüleyin',
                    iconColor: AppColors.primary,
                    gradientColors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.1),
                    ],
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FeatureCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'İslam Etkinlikleri',
                    description: 'Dini günleri ve olayları belirlemek için İslami takvim',
                    iconColor: AppColors.secondary,
                    gradientColors: [
                      AppColors.secondary.withValues(alpha: 0.2),
                      AppColors.secondary.withValues(alpha: 0.1),
                    ],
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FeatureCard(
                    icon: Icons.circle_rounded,
                    title: 'Tesbih',
                    description: 'Allah büyüktür, tüm dualar Allah içindir ve Allah her şeyden üstündür',
                    iconColor: AppColors.success,
                    gradientColors: [
                      AppColors.success.withValues(alpha: 0.2),
                      AppColors.success.withValues(alpha: 0.1),
                    ],
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FeatureCard(
                    icon: Icons.group_add_rounded,
                    title: 'Topluluğumuza Katıl',
                    description: 'Takvapp topluluğuna katılın ve diğer kullanıcılarla bağlantı kurun',
                    iconColor: const Color(0xFF9B59B6),
                    gradientColors: [
                      const Color(0xFF9B59B6).withValues(alpha: 0.2),
                      const Color(0xFF9B59B6).withValues(alpha: 0.1),
                    ],
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color iconColor;
  final List<Color> gradientColors;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.iconColor,
    required this.gradientColors,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(36);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: widget.onTap,
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) => _controller.reverse(),
                onTapCancel: () => _controller.reverse(),
                splashColor: widget.iconColor.withValues(alpha: 0.1),
                highlightColor: widget.iconColor.withValues(alpha: 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.surfaceHigh.withValues(alpha: 0.5),
                        AppColors.surface.withValues(alpha: 0.4),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.06),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: widget.gradientColors,
                              ),
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(
                                  widget.icon,
                                  color: widget.iconColor,
                                  size: 32,
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.title,
                                        style: AppTextStyles.headingM.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.description,
                                        style: AppTextStyles.bodyM.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white.withValues(alpha: 0.05),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
