import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_routes.dart';

class TrackTile extends StatelessWidget {
  final String index;
  final String title;
  final String artist;
  final String duration;
  final bool active;
  final bool showImage;
  final String? imageUrl;
  final String? subtitle;
  final VoidCallback? onTap;

  const TrackTile({
    super.key,
    required this.index,
    required this.title,
    required this.artist,
    required this.duration,
    this.active = false,
    this.showImage = false,
    this.imageUrl,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pushNamed(context, AppRoutes.nowPlaying),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A1414) : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              child: Text(
                index,
                style: TextStyle(
                  color: active ? const Color(0xFFFF8A1D) : Colors.white38,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            if (showImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  imageUrl ?? '',
                  width: 42.w,
                  height: 42.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    subtitle ?? artist,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(width: 10.w),
            const Icon(Icons.more_vert, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}