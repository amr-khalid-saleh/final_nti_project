import 'package:flutter/material.dart';
import '../widgets/mood_grid_widget.dart';
import '../widgets/next_button_widget.dart';
import '../widgets/dots_indicator_widget.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

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
            colors: [Color(0xFF0D0500), Color(0xFF1A0A00), Color(0xFF0D0500)],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                _TopBar(),

                const SizedBox(height: 20),

                const MoodGridWidget(),

                const Spacer(),

                _TextSection(),

                const SizedBox(height: 32),

                NextButtonWidget(
                  onTap: () {
                    // TODO: navigation 
                  },
                ),
                const SizedBox(height: 16),

                Center(
                  child: const DotsIndicatorWidget(
                    totalDots: 3,
                    activeDot: 1, 
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Musix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        GestureDetector(
          onTap: () {
          },
          child: Icon(
            Icons.close,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _TextSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Curate\nYour Mood',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Build the perfect soundtrack for\nevery moment.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
