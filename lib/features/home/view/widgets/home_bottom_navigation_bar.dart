import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';
import 'package:takvapp_mobile/features/home/view/widgets/fluid_glass_effect.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const HomeBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<HomeBottomNavigationBar> createState() => _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  bool? _preferLiquidStyle;

  @override
  void initState() {
    super.initState();
    _resolveStyle();
  }

  Future<void> _resolveStyle() async {
    final result = await _detectLiquidAvailability();
    if (mounted) setState(() => _preferLiquidStyle = result);
  }

  static Future<bool> _detectLiquidAvailability() async {
    if (!Platform.isIOS) return false;
    try {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final versionString = iosInfo.systemVersion;
      final major = int.tryParse(versionString.split('.').first) ?? 0;
      // iOS 18 corresponds to Darwin 22+ but the request references iOS 26 beta naming.
      // We treat 18 and above as supporting the fully liquid tab bar.
      return major >= 18;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final useLiquid = _preferLiquidStyle ?? Platform.isIOS;
    final items = _navItems;

    // Wrap in a proper container to prevent ParentDataWidget issues
    return Material(
      type: MaterialType.transparency,
      child: useLiquid
          ? _LiquidGlassNavBar(
              selectedIndex: widget.selectedIndex,
              onItemTapped: widget.onItemTapped,
              items: items,
            )
          : _ClassicNavBar(
              selectedIndex: widget.selectedIndex,
              onItemTapped: widget.onItemTapped,
              items: items,
            ),
    );
  }
}

class _LiquidGlassNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<_NavItem> items;

  const _LiquidGlassNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  State<_LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<_LiquidGlassNavBar> {
  final GlobalKey<FluidGlassEffectState> _fluidGlassKey = GlobalKey();

  void _handleTapDown(TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final localPosition = box.globalToLocal(details.globalPosition);
      _fluidGlassKey.currentState?.showEffectAtPosition(localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = isDark 
        ? AppColors.background.withValues(alpha: 0.15)
        : AppColors.white.withValues(alpha: 0.2);

    return SizedBox(
      height: 86 + AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          bottom: AppSpacing.lg,
        ),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          behavior: HitTestBehavior.translucent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          overlayColor,
                          overlayColor.withValues(alpha: isDark ? 0.12 : 0.16),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 86,
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final selected = index == widget.selectedIndex;
                        return Expanded(
                          child: _LiquidNavItem(
                            icon: item.icon,
                            svgPath: item.svgPath,
                            label: item.label,
                            selected: selected,
                            onTap: () => widget.onItemTapped(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -20,
                height: 20,
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(44),
                        topRight: Radius.circular(44),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          overlayColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: FluidGlassEffect(
                    key: _fluidGlassKey,
                    scale: 0.25,
                    blurRadius: 30.0,
                    animationDuration: const Duration(milliseconds: 300),
                    visibleDuration: const Duration(milliseconds: 500),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _LiquidNavItem extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LiquidNavItem({
    this.icon,
    this.svgPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        style: (selected
                ? AppTextStyles.bodyS.copyWith(color: AppColors.white)
                : AppTextStyles.bodyS.copyWith(color: AppColors.white.withValues(alpha: 0.65)))
            .copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutBack,
              scale: selected ? 1.02 : 0.94,
              child: svgPath != null
                  ? SvgPicture.asset(
                      svgPath!,
                      width: selected ? 26 : 24,
                      height: selected ?26 : 24,
                      colorFilter: ColorFilter.mode(
                        selected ? AppColors.white : AppColors.white.withValues(alpha: 0.75),
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon!,
                      color: selected ? AppColors.white : AppColors.white.withValues(alpha: 0.75),
                      size: selected ? 26 : 24,
                    ),
            ),
            const SizedBox(height: 6),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0.78,
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassicNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<_NavItem> items;

  const _ClassicNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  State<_ClassicNavBar> createState() => _ClassicNavBarState();
}

class _ClassicNavBarState extends State<_ClassicNavBar> {
  final GlobalKey<FluidGlassEffectState> _fluidGlassKey = GlobalKey();

  void _handleTapDown(TapDownDetails details) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final localPosition = box.globalToLocal(details.globalPosition);
      _fluidGlassKey.currentState?.showEffectAtPosition(localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlayColor = isDark 
        ? AppColors.background.withValues(alpha: 0.15)
        : AppColors.white.withValues(alpha: 0.2);

    return SizedBox(
      height: 80 + AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          bottom: AppSpacing.lg,
        ),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          behavior: HitTestBehavior.translucent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          overlayColor,
                          overlayColor.withValues(alpha: isDark ? 0.12 : 0.16),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(widget.items.length, (index) {
                        final item = widget.items[index];
                        final selected = index == widget.selectedIndex;
                        return Expanded(
                          child: _ClassicNavItem(
                            icon: item.icon,
                            svgPath: item.svgPath,
                            label: item.label,
                            selected: selected,
                            onTap: () => widget.onItemTapped(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: -20,
                height: 20,
                child: IgnorePointer(
                  ignoring: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          overlayColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: true,
                  child: FluidGlassEffect(
                    key: _fluidGlassKey,
                    scale: 0.25,
                    blurRadius: 30.0,
                    animationDuration: const Duration(milliseconds: 300),
                    visibleDuration: const Duration(milliseconds: 500),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _ClassicNavItem extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ClassicNavItem({
    this.icon,
    this.svgPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        style: (selected
                ? AppTextStyles.bodyS.copyWith(color: AppColors.white)
                : AppTextStyles.bodyS.copyWith(color: AppColors.white.withValues(alpha: 0.65)))
            .copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              scale: selected ? 1.0 : 0.92,
              child: svgPath != null
                  ? SvgPicture.asset(
                      svgPath!,
                      width: selected ? 26 : 24,
                      height: selected ? 26 : 24,
                      colorFilter: ColorFilter.mode(
                        selected ? AppColors.white : AppColors.white.withValues(alpha: 0.75),
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon!,
                      color: selected ? AppColors.white : AppColors.white.withValues(alpha: 0.75),
                      size: selected ? 26 : 24,
                    ),
            ),
            const SizedBox(height: 6),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0.78,
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData? icon;
  final String? svgPath;
  final String label;

  const _NavItem({
    this.icon,
    this.svgPath,
    required this.label,
  }) : assert(icon != null || svgPath != null, 'Either icon or svgPath must be provided');
}

const List<_NavItem> _navItems = [
  _NavItem(icon: Icons.home_filled, label: 'Home'),
  _NavItem(svgPath: 'assets/images/qibla_icon.svg', label: 'Qibla'),
  _NavItem(icon: Icons.access_time_filled_rounded, label: 'Prayer'),
  _NavItem(icon: Icons.menu_book_rounded, label: 'Quran'),
  _NavItem(icon: Icons.explore_rounded, label: 'Explore'),
];
