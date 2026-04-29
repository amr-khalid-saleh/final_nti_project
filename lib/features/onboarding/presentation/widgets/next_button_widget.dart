// 📁 lib/features/onboarding/presentation/widgets/next_button_widget.dart
//
// مسؤوليته: رسم زرار Next البرتقالي
// قابل لإعادة الاستخدام في كل شاشات الـ Onboarding

import 'package:flutter/material.dart';

class NextButtonWidget extends StatelessWidget {
  // onTap: الـ callback اللي بيتنفذ لما المستخدم يضغط
  // required: لازم تبعته لما تستخدم الـ widget
  final VoidCallback onTap;

  const NextButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // لما يضغط، نفذ الـ callback
      child: Container(
        width: double.infinity, // عرض كامل
        height: 56,
        decoration: BoxDecoration(
          // اللون البرتقالي-الأحمر
          color: const Color(0xFFE84818),
          borderRadius: BorderRadius.circular(50), // شكل pill مدور
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}