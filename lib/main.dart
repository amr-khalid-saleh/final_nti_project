import 'package:flutter/material.dart';
import 'core/theming/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'features/home/presentation/screens/home_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/library/presentation/screens/album_details_screen.dart';
// import 'features/library/presentation/screens/artist_details_screen.dart';
// import 'features/library/presentation/screens/library_splash_screen.dart';


void main() {
  runApp(const MusixApp());
}

class MusixApp extends StatelessWidget {
  const MusixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            fontFamily: 'SFProDisplay',
          ),
          home: child,
        );
      },
      child: const AlbumDetailsScreen(),
    );
  }
}