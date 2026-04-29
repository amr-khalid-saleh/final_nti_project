// 📁 lib/features/onboarding/presentation/screens/onboarding1_screen.dart
//
// الشاشة الأولى من الـ Onboarding
// مسؤوليته: يرتب الـ widgets بس — مش فيه أي رسم تفصيلي

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

        // الخلفية: صورة الـ wallpaper مع طبقة داكنة فوقها
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0x99000000), // 0x99 = 60% شفافية سوداء
              BlendMode.darken,
            ),
          ),
        ),

        child: SafeArea(
          // SafeArea: بيحمي المحتوى من الـ notch والـ status bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ① اسم التطبيق
                _TopBar(),

                const SizedBox(height: 20),

                // ② الاسطوانة الدوارة
                const VinylWidget(),

                // Spacer: بيملا المساحة الفاضية بين الـ vinyl والنص
                const Spacer(),

                // ③ العنوان والـ subtitle
                _TextSection(),

                const SizedBox(height: 36),

                // ④ زرار Next — بنبعتله onTap فاضي دلوقتي
                NextButtonWidget(
                  onTap: () {
                    // TODO: هنضيف Navigation للشاشة التانية هنا
                  },
                ),

                const SizedBox(height: 16),

                // ⑤ النقط — الشاشة الأولى (activeDot: 0)
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

// ─────────────────────────────────────────
// Private Widgets — خاصة بالشاشة دي بس
// مش محتاجة ملفات منفصلة لأنها بسيطة
// ─────────────────────────────────────────

// اسم التطبيق في الأعلى
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

// العنوان الكبير + النص التوضيحي
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