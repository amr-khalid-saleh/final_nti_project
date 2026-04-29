import 'package:flutter/material.dart';

import '../widgets/dots_indicator_widget.dart';
import '../widgets/next_button_widget.dart';
import '../widgets/onboarding_text_section.dart';
import '../widgets/onboarding_top_bar.dart';
import '../../../../core/utils/app_routes.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/onboarding_background.png'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0500), Color(0xFF1A0A00), Color(0xFF0D0500)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                OnboardingTopBar(),

                Spacer(),
                const SizedBox(height: 24),

                OnboardingTextSection(
                  title: 'Discover\nEndless Music',
                  subtitle:
                      'Millions of songs, playlists, and artists\nat your fingertips.',
                ),

                SizedBox(height: 32),

                // Next Button
                NextButtonWidget(onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                }),
                const SizedBox(height: 16),

                // Dots Indicator
                OnboardingDotsIndicator(totalDots: 3, activeDot: 2),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
