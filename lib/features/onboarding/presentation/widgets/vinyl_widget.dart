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
  void dispose() {
    _spinController.dispose(); // مهم جداً — يمنع memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Image.asset(
        'assets/images/Border_OverlayBlur.png',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}
