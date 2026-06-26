import 'package:flutter/material.dart';

class ShareAndHelpHeader extends StatelessWidget {
  const ShareAndHelpHeader({super.key, required this.onCreatePost});

  final VoidCallback onCreatePost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share & Help',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ask neighbours for help, share useful things, and strengthen your building community.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Post'),
            ),
          ),
        ],
      ),
    );
  }
}
