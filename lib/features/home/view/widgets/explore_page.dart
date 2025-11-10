import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/profile/view/profile_page.dart';
import 'package:takvapp_mobile/features/statistics/view/statistics_page.dart';
import 'package:takvapp_mobile/features/tesbih/view/tesbih_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.getBackgroundGradient(context),
        ),
      ),
      child: SafeArea(
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keşfet',
                            style: AppTextStyles.displayL.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.white
                                  : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'İslami içerik ve özellikler',
                            style: AppTextStyles.bodyM.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                )),
                                child: child,
                              );
                            },
                            opaque: false,
                            barrierColor: Colors.black.withValues(alpha: 0.5),
                          ),
                        );
                      },
                      child: Builder(
                        builder: (context) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.3),
                                  AppColors.secondary.withValues(alpha: 0.2),
                                ],
                              ),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.white.withValues(alpha: 0.1)
                                    : AppColors.lightTextMuted.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.2)
                                      : Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDark
                                        ? AppColors.surfaceHigh.withValues(alpha: 0.3)
                                        : AppColors.lightSurfaceHigh.withValues(alpha: 0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/images/profile_icon.svg',
                                      width: 28,
                                      height: 28,
                                      colorFilter: ColorFilter.mode(
                                        isDark ? AppColors.white : AppColors.lightTextPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
                    icon: Icons.analytics_rounded,
                    title: 'İstatistikler',
                    description: 'Kuran okuma, namaz, hatim ve zikir istatistiklerinizi görüntüleyin',
                    iconColor: const Color(0xFF4D8DFF),
                    gradientColors: [
                      const Color(0xFF4D8DFF).withValues(alpha: 0.2),
                      const Color(0xFF4D8DFF).withValues(alpha: 0.1),
                    ],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StatisticsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                    svgPath: 'assets/images/tesbih.svg',
                    title: 'Tesbih',
                    description: 'Allah büyüktür, tüm dualar Allah içindir ve Allah her şeyden üstündür',
                    iconColor: AppColors.success,
                    gradientColors: [
                      AppColors.success.withValues(alpha: 0.2),
                      AppColors.success.withValues(alpha: 0.1),
                    ],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TesbihPage(),
                        ),
                      );
                    },
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
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
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
  final IconData? icon;
  final String? svgPath;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color iconColor;
  final List<Color> gradientColors;

  const _FeatureCard({
    this.icon,
    this.svgPath,
    required this.title,
    required this.description,
    required this.onTap,
    required this.iconColor,
    required this.gradientColors,
  }) : assert(icon != null || svgPath != null, 'Either icon or svgPath must be provided');

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    color: isDark
                        ? const Color(0xFF1A1F2E)
                        : AppColors.lightSurface.withValues(alpha: 0.95),
                    border: Border.all(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.06)
                          : AppColors.lightTextMuted.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: isDark
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildCardContent(isDark),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildCardContent(isDark),
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

  Widget _buildCardContent(bool isDark) {
    return Row(
      children: [
        widget.svgPath != null
            ? SvgPicture.asset(
                widget.svgPath!,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? AppColors.white.withValues(alpha: 0.75)
                      : AppColors.lightTextPrimary,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                widget.icon!,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.75)
                    : AppColors.lightTextPrimary,
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
                  color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.description,
                style: AppTextStyles.bodyM.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
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
            color: isDark
                ? AppColors.white.withValues(alpha: 0.05)
                : AppColors.lightTextMuted.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDark
                ? AppColors.textSecondary.withValues(alpha: 0.6)
                : AppColors.lightTextMuted,
            size: 14,
          ),
        ),
      ],
    );
  }
}
