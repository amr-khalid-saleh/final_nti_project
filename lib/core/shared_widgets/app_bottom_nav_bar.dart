import 'package:flutter/material.dart';
import '../../core/theming/app_colors.dart';
import '../../core/utils/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
        break;
      case 1: break;
      case 2: break;
      case 3: break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // الـ Container الخارجي شفاف تماماً — الـ padding بس
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bottomNavBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.divider, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.accent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _onTap(context, index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.iconInactive,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'EXPLORE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music_outlined),
                activeIcon: Icon(Icons.library_music),
                label: 'LIBRARY',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_outlined),
                activeIcon: Icon(Icons.workspace_premium),
                label: 'PREMIUM',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
