// 📁 lib/features/onboarding/presentation/screens/onboarding2_screen.dart
//
// الشاشة التانية من الـ Onboarding
// مسؤوليته: يرتب الـ widgets بس — مفيهوش منطق

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

        // نفس الخلفية الداكنة من الشاشة الأولى
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

                // ① الـ TopBar (X زرار + Musix)
                _TopBar(),

                const SizedBox(height: 20),

                // ② الـ Grid بتاع الكروت
                const MoodGridWidget(),

                const Spacer(),

                // ③ النص الرئيسي
                _TextSection(),

                const SizedBox(height: 32),

                // ④ زرار Next
                NextButtonWidget(
                  onTap: () {
                    // TODO: navigation للشاشة التالتة
                  },
                ),
                const SizedBox(height: 16),

                // ⑤ النقط — النقطة التانية نشطة (activeDot: 1)
                Center(
                  child: const DotsIndicatorWidget(
                    totalDots: 3,
                    activeDot: 1, // ← الشاشة التانية
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

// شريط العنوان: Musix + زرار X
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // اسم التطبيق
        const Text(
          'Musix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        // زرار الإغلاق
        GestureDetector(
          onTap: () {
            // هنا ممكن تضيف navigation لو عايز
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

// النصوص: العنوان + الـ subtitle
class _TextSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان الكبير
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

        // النص التوضيحي
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
