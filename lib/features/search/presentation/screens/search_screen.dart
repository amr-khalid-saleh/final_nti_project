import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Placeholder(fallbackHeight: 50),

              const SizedBox(height: 24),

              const Placeholder(fallbackHeight: 52),

              const SizedBox(height: 32),

              const Placeholder(fallbackHeight: 30),

              const SizedBox(height: 20),

              const Expanded(
                child: Placeholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}