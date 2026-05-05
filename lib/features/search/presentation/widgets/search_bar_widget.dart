import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSubmitted;

  const SearchBarWidget({super.key, this.onSubmitted});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    widget.onSubmitted?.call(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSearch,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Artists, songs, or podcasts',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.white54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Tap the search icon to submit on mobile without keyboard action
          GestureDetector(
            onTap: () => _handleSearch(_controller.text),
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF1DB954),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}