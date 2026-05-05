import 'dart:developer';

import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile_img.png'),
        ),
        const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            // TODO: Open filter
            log('Filter button tapped');
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}