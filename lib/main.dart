import 'package:flutter/material.dart';
import 'package:musix/features/onboarding/presentation/screens/onboarding2_screen.dart';

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
      home: const Onboarding2Screen(), // ← غيرت هنا
    );
  }
}