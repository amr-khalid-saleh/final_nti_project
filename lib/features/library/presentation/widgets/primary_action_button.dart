import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final bool outlined;

  const PrimaryActionButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.width,
    this.backgroundColor = const Color(0xFFFF4B2B),
    this.textColor = Colors.white,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 150.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: outlined ? Colors.white24 : Colors.transparent,
          ),
          boxShadow: outlined
              ? null
              : [
            BoxShadow(
              color: backgroundColor.withOpacity(.35),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 18.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}