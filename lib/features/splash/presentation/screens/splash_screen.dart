import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const splashTitle = 'Musix';
    const splashSubtitle = 'SOUND UNBOUND';
    const splashBottomText = 'Premium Listening Experience';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.2,
            colors: [
              Color(0xFFFF2D12).withValues(alpha: 0.35),
              Colors.black45,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: .18,
                child: Image.asset(
                  'assets/images/splash_background_image.png',
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
                          fontSize: 20.sp,
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
