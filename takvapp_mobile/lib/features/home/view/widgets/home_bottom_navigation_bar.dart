import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';
import 'package:takvapp_mobile/core/theme/app_spacing.dart';
import 'package:takvapp_mobile/core/theme/app_text_styles.dart';

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

    if (useLiquid) {
      return _LiquidGlassNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
        items: items,
      );
    }

    return _ClassicNavBar(
      selectedIndex: widget.selectedIndex,
      onItemTapped: widget.onItemTapped,
      items: items,
    );
  }
}

class _LiquidGlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<_NavItem> items;

  const _LiquidGlassNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.lg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withValues(alpha: 0.18),
                  AppColors.white.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 18)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                final indicatorWidth = itemWidth * 0.78;
                final indicatorLeft = (itemWidth * selectedIndex) + (itemWidth - indicatorWidth) / 2;

                return SizedBox(
                  height: 86,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 360),
                        curve: Curves.easeOutCubic,
                        left: indicatorLeft,
                        bottom: 20,
                        child: _LiquidIndicator(width: indicatorWidth),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          final selected = index == selectedIndex;
                          return Expanded(
                            child: _LiquidNavItem(
                              icon: item.icon,
                              label: item.label,
                              selected: selected,
                              onTap: () => onItemTapped(index),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidIndicator extends StatelessWidget {
  final double width;

  const _LiquidIndicator({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
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
              color: const Color(0xFF64F2FF).withValues(alpha: 0.35),
              blurRadius: 36,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.white.withValues(alpha: 0.32),
                    AppColors.white.withValues(alpha: 0.08),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LiquidNavItem({
    required this.icon,
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
              child: Icon(
                icon,
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

class _ClassicNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<_NavItem> items;

  const _ClassicNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.lg,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1F2A),
          borderRadius: BorderRadius.circular(36),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BottomNavigationBar(
            items: items
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
                )
                .toList(),
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.white.withValues(alpha: 0.4),
            selectedLabelStyle: AppTextStyles.bodyS.copyWith(color: AppColors.white),
            unselectedLabelStyle: AppTextStyles.bodyS.copyWith(color: AppColors.white.withValues(alpha: 0.4)),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}

const List<_NavItem> _navItems = [
  _NavItem(Icons.home_filled, 'Home'),
  _NavItem(Icons.explore_rounded, 'Qibla'),
  _NavItem(Icons.access_time_filled_rounded, 'Prayer'),
  _NavItem(Icons.auto_graph_rounded, 'Insights'),
  _NavItem(Icons.menu_book_rounded, 'Quran'),
];
