import 'dart:math';
import 'package:flutter/material.dart';

class VinylWidget extends StatefulWidget {
  const VinylWidget({super.key});

  @override
  State<VinylWidget> createState() => _VinylWidgetState();
}

class _VinylWidgetState extends State<VinylWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 4),
    )..repeat(); 
  }

  @override
  void dispose() {
    _spinController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: _spinController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _spinController.value * 2 * pi,
            child: child,
          );
        },
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
