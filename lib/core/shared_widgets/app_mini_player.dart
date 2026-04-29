import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';
import '../theming/app_text_styles.dart';

class AppMiniPlayer extends StatelessWidget {
  const AppMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?auto=format&fit=crop&w=100&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Midnight City Lights', style: AppTextStyles.font14WhiteMedium),
                Text('The Midnight Specter', style: AppTextStyles.font11GreyMedium),
              ],
            ),
          ),
          Icon(Icons.favorite_border, color: Colors.white, size: 24.sp),
          SizedBox(width: 16.w),
          Icon(Icons.pause, color: Colors.white, size: 28.sp),
        ],
      ),
    );
  }
}
