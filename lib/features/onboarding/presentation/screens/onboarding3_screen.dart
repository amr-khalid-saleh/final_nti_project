import 'package:flutter/material.dart';

import '../widgets/onboarding_top_bar.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0500),
              Color(0xFF1A0A00),
              Color(0xFF0D0500),
            ],
          ),
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                OnboardingTopBar(),
                SizedBox(height: 40),

                Expanded(
                  child: Center(
                    child: Placeholder(fallbackHeight: 300),
                  ),
                ),

                Placeholder(fallbackHeight: 120),

                SizedBox(height: 32),

                Placeholder(fallbackHeight: 56),

                SizedBox(height: 16),

                Center(
                  child: Placeholder(fallbackHeight: 10, fallbackWidth: 80),
                ),

                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}