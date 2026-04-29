// 📁 lib/features/onboarding/presentation/widgets/vinyl_widget.dart
//
// مسؤوليته: رسم الاسطوانة الدوارة
// فيه أنيميشن واحد: دوران

import 'dart:math';
import 'package:flutter/material.dart';

class VinylWidget extends StatefulWidget {
  const VinylWidget({super.key});

  @override
  State<VinylWidget> createState() => _VinylWidgetState();
}

// StatefulWidget لأن فيه أنيميشن محتاج state
class _VinylWidgetState extends State<VinylWidget>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin: لأن عندنا أنيميشن واحد بس

  late AnimationController _spinController;
  // late: يعني هنعمل initialize بعدين في initState

  @override
  void initState() {
    super.initState();

    // إعداد الدوران: دورة كاملة كل 4 ثواني، يكرر للأبد
    _spinController = AnimationController(
      vsync: this, // this = الـ SingleTickerProviderStateMixin
      duration: const Duration(seconds: 4),
    )..repeat(); // ..repeat() = ابدأ وكرر فوراً
  }

  @override
  void dispose() {
    _spinController.dispose(); // مهم جداً — يمنع memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        // AnimatedBuilder: بيعيد رسم الـ widget كل frame
        animation: _spinController,
        builder: (context, child) {
          return Transform.rotate(
            // _spinController.value: بيروح من 0.0 لـ 1.0
            // × 2π = دورة كاملة بالـ radians
            angle: _spinController.value * 2 * pi,
            child: child,
          );
        },
        // child: بيتبنى مرة واحدة بس — مش بيتعمل rebuild مع كل frame
        child: Image.asset(
          'assets/images/Border_OverlayBlur.png',
          width: 220,
          height: 220,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}