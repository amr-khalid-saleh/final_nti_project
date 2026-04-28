import 'package:flutter/material.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_bar_widget.dart';

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
              const SizedBox(height: 8),
              const SearchAppBar(),

              const SizedBox(height: 20),
              const SearchBarWidget(),

              const SizedBox(height: 32),

              // Browse Categories Title (placeholder)
              const Placeholder(fallbackHeight: 30),

              const SizedBox(height: 16),

              // Categories Grid (placeholder)
              const Expanded(
                flex: 2,
                child: Placeholder(),
              ),

              const SizedBox(height: 32),

              // Trending Artists Title (placeholder)
              const Placeholder(fallbackHeight: 30),

              const SizedBox(height: 16),

              // Trending Artists (placeholder)
              const Placeholder(fallbackHeight: 90),

              const SizedBox(height: 32),

              // Discover Section (placeholder)
              const Placeholder(fallbackHeight: 200),
            ],
          ),
        ),
      ),
    );
  }
}