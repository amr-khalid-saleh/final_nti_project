import 'package:flutter/material.dart';
//import 'package:musix/features/onboarding/presentation/screens/onboarding2_screen.dart';
import 'package:musix/features/profile/presentation/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musix',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
<<<<<<< HEAD
      home: const ProfileScreen(), // ← غيرت هنا
=======
      home: const Onboarding2Screen(), 
>>>>>>> f42a10b278fc84d30507169f035c9eb1c9216c3a
    );
  }
}
