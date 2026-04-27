import 'package:flutter/material.dart';
import '../widgets/vinyl_widget.dart';
import '../widgets/next_button_widget.dart';
import '../widgets/dots_indicator_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0x99000000), // 0x99 = 60% 
              BlendMode.darken,
            ),
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                const SizedBox(height: 16),

                _TopBar(),

                const SizedBox(height: 20),

                const VinylWidget(),

                const Spacer(),

                _TextSection(),

                const SizedBox(height: 36),

                NextButtonWidget(
                  onTap: () {
                  },
                ),

                const SizedBox(height: 16),

                const DotsIndicatorWidget(
                  totalDots: 3,
                  activeDot: 0,
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Musix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
      children: [
        const Text(
          'Discover Your\nSound',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Explore millions of tracks tailored\njust for you.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
