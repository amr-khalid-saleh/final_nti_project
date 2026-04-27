import 'package:flutter/material.dart';

class DotsIndicatorWidget extends StatelessWidget {
  final int totalDots;  
  final int activeDot;  

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
        final isActive = index == activeDot;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 18.0 : 6.0,  
            height: 6.0,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFE84818)          
                  : Colors.white.withOpacity(0.3),  
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
