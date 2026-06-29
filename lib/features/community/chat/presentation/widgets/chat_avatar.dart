import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.radius = 18,
  });

  final String displayName;
  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = displayName.trim().isEmpty
        ? '?'
        : displayName.trim().characters.first.toUpperCase();

    return CircleAvatar(
      radius: radius,
      backgroundImage: avatarUrl == null || avatarUrl!.trim().isEmpty
          ? null
          : NetworkImage(avatarUrl!),
      child: avatarUrl == null || avatarUrl!.trim().isEmpty
          ? Text(initial, style: const TextStyle(fontWeight: FontWeight.w700))
          : null,
    );
  }
}
