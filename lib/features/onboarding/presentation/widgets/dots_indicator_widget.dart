// 📁 lib/features/onboarding/presentation/widgets/dots_indicator_widget.dart
//
// مسؤوليته: رسم نقط الصفحات
// بيستقبل عدد النقط والنقطة النشطة

import 'package:flutter/material.dart';

class DotsIndicatorWidget extends StatelessWidget {
  final int totalDots;  // عدد الصفحات الكلي
  final int activeDot;  // رقم الصفحة الحالية (يبدأ من 0)

  const DotsIndicatorWidget({
    super.key,
    required this.totalDots,
    required this.activeDot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        // List.generate: بتعمل list بعدد totalDots
        // كل عنصر فيها نقطة
        final isActive = index == activeDot;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: AnimatedContainer(
            // AnimatedContainer: بيعمل transition تلقائي لما القيم تتغير
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 18.0 : 6.0,  // النشطة أعرض
            height: 6.0,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFE84818)          // نشطة: برتقالي
                  : Colors.white.withOpacity(0.3),   // غير نشطة: أبيض شفاف
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}