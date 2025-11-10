import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takvapp_mobile/core/services/theme_service.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showThemeDialog(BuildContext context) {
    final themeService = context.read<ThemeService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.3)
                    : AppColors.lightTextMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Tema Seç',
              style: AppTextStyles.displayL.copyWith(
                color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ThemeOption(
              title: 'Koyu Mod',
              icon: Icons.dark_mode_rounded,
              themeMode: ThemeMode.dark,
              isSelected: themeService.themeMode == ThemeMode.dark,
              onTap: () {
                themeService.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _ThemeOption(
              title: 'Aydınlık Mod',
              icon: Icons.light_mode_rounded,
              themeMode: ThemeMode.light,
              isSelected: themeService.themeMode == ThemeMode.light,
              onTap: () {
                themeService.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _ThemeOption(
              title: 'Sistem Ayarı',
              icon: Icons.brightness_auto_rounded,
              themeMode: ThemeMode.system,
              isSelected: themeService.themeMode == ThemeMode.system,
              onTap: () {
                themeService.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Arka plan gradient'i
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.getProfileBackgroundGradient(context),
              ),
            ),
          ),
          // Modal içerik
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.83,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.getProfileBackgroundGradient(context),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: AppSpacing.md),
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.white.withValues(alpha: 0.3)
                            : AppColors.lightTextMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Header with title and close button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.lg,
                      ),
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ayarlar',
                        style: AppTextStyles.displayL.copyWith(
                          color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.surfaceHigh.withValues(alpha: 0.3)
                                : AppColors.lightSurfaceHigh.withValues(alpha: 0.3),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        // Profile Section
                        Builder(
                          builder: (context) {
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.lg,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
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
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: Image.asset(
                                        'assets/images/profile.png',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDark
                                                  ? AppColors.surfaceHigh
                                                  : AppColors.lightSurfaceHigh,
                                            ),
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: isDark
                                                  ? AppColors.white
                                                  : AppColors.lightTextPrimary,
                                              size: 32,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fethi Omur',
                                          style: AppTextStyles.displayL.copyWith(
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.lightTextPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to account management
                                          },
                                          child: Text(
                                            'Hesabı Yönet',
                                            style: AppTextStyles.bodyM.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // App Settings Section
                        Builder(
                          builder: (context) {
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                              child: Text(
                                'Uygulama Ayarları',
                                style: AppTextStyles.bodyS.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SettingsItem(
                          icon: Icons.flash_on_rounded,
                          title: 'Üyelik',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.brightness_6_rounded,
                          title: 'Tema',
                          onTap: () {
                            _showThemeDialog(context);
                          },
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.language_rounded,
                          title: 'Uygulama Dili',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.location_on_rounded,
                          title: 'Konum',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.notifications_rounded,
                          title: 'Bildirimler',
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.card_giftcard_rounded,
                          title: 'Arkadaşları Davet Et',
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                            child: const Icon(
                              Icons.celebration_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        // Support Section
                        Builder(
                          builder: (context) {
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                              child: Text(
                                'Destek',
                                style: AppTextStyles.bodyS.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _SettingsItem(
                          icon: Icons.flash_on_rounded,
                          title: 'Hizmet Şartları',
                          showChevron: false,
                          onTap: () {},
                        ),
                        _Divider(),
                        _SettingsItem(
                          icon: Icons.credit_card_rounded,
                          title: 'Gizlilik Politikası',
                          showChevron: false,
                          onTap: () {},
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 0,
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
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showChevron = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(
                    color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? AppColors.textSecondary.withValues(alpha: 0.5)
                      : AppColors.lightTextMuted,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xl + 24 + AppSpacing.lg),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark
            ? AppColors.textSecondary.withValues(alpha: 0.1)
            : AppColors.lightTextMuted.withValues(alpha: 0.2),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode themeMode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.themeMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyM.copyWith(
                  color: isSelected
                      ? (isDark ? AppColors.white : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
