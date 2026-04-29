import 'package:flutter/material.dart';
import '../widgets/profile_app_bar_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/stats_row_widget.dart';
import '../widgets/subscription_card_widget.dart';
import '../widgets/recent_activity_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileAppBarWidget(),

              const SizedBox(height: 20),

              const ProfileHeaderWidget(),

              const SizedBox(height: 24),

              const StatsRowWidget(),

              const SizedBox(height: 20),

              const SubscriptionCardWidget(),

              const SizedBox(height: 24),

              const RecentActivityWidget(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_outlined,
              color: Colors.white.withOpacity(0.4), size: 24),
          Icon(Icons.search,
              color: Colors.white.withOpacity(0.4), size: 24),
          Icon(Icons.library_music_outlined,
              color: Colors.white.withOpacity(0.4), size: 24),
          const Icon(Icons.person,
              color: Color(0xFFE84818), size: 24),
        ],
      ),
    );
  }
}
