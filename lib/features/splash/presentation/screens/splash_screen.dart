import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  final splashTitle = 'Musix';
  final splashSubtitle = 'SOUND UNBOUND';
  final splashBottomText = 'Premium Listening Experience';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.2,
            colors: [Color(0xFF5A1207), Color(0xFF170503), Colors.black],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: .18,
                child: Image.network(
                  'https://images.unsplash.com/photo-1516280440614-37939bbacd81?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 70.h),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    splashTitle,
                    style: TextStyle(
                      color: const Color(0xFFFF4B2B),
                      fontSize: 72.sp,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    splashSubtitle,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 22.sp,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Container(
                    width: 100.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4B2B),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.multitrack_audio,
                        color: const Color(0xFFFF4B2B),
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        splashBottomText,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
