import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_bottom_nav_bar.dart';
import 'app_mini_player.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final bool showMiniPlayer;
  final bool showBottomNav;

  const MainScaffold({
    super.key,
    required this.body,
    this.currentIndex = 0,
    this.showMiniPlayer = true,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          body,
          if (showMiniPlayer)
            Positioned(
              bottom: showBottomNav ? 110.h : 20.h,
              left: 16.w,
              right: 16.w,
              child: const AppMiniPlayer(),
            ),
          if (showBottomNav)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AppBottomNavBar(currentIndex: currentIndex),
            ),
        ],
      ),
    );
  }
}
