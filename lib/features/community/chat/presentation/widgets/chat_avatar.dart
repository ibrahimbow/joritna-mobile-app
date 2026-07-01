import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.size = 36,
  });

  final String displayName;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cleanAvatarUrl = avatarUrl?.trim();

    if (cleanAvatarUrl == null || cleanAvatarUrl.isEmpty) {
      return _FallbackAvatar(displayName: displayName, size: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Image.network(
          cleanAvatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          headers: const {
            'Accept': 'image/*',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return _FallbackAvatar(displayName: displayName, size: size);
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Avatar image failed: $cleanAvatarUrl');
            debugPrint('Avatar error: $error');

            return _FallbackAvatar(displayName: displayName, size: size);
          },
        ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({
    required this.displayName,
    required this.size,
  });

  final String displayName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmedName = displayName.trim();

    final initial = trimmedName.isEmpty ? '?' : trimmedName[0].toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE0EAFF),
      ),
      child: Text(
        initial,
        style: TextStyle(
          color: const Color(0xFF3056A3),
          fontSize: size * 0.42,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}