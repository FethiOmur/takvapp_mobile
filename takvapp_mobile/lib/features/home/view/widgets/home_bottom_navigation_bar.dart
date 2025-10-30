import 'package:flutter/material.dart';
import 'package:takvapp_mobile/core/theme/app_colors.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const HomeBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Qibla',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Prayer Times',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Quran',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.darkGrey.withOpacity(0.9),
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
