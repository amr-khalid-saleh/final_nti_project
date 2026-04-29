import 'package:flutter/material.dart';

class NextButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const NextButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        width: double.infinity, 
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFE84818),
          borderRadius: BorderRadius.circular(50), 
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
