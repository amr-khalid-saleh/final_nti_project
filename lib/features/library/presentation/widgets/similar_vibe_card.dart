import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimilarVibeCard extends StatelessWidget {
  final String title;
  final String artist;
  final String image;

  const SimilarVibeCard({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.network(
              image,
              width: double.infinity,
              height: 120.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            artist,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}