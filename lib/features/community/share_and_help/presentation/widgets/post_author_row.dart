import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/string_utils.dart';

class PostAuthorRow extends StatelessWidget {
  const PostAuthorRow({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
    required this.canEdit,
    required this.onEdit,
    required this.canDelete,
    required this.onDelete,
    this.isDeleting = false,
  });

  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  final bool canEdit;
  final VoidCallback onEdit;

  final bool canDelete;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final resolvedAvatarUrl = FileUrlResolver.resolve(avatarUrl);

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE6EFFD),
          backgroundImage: resolvedAvatarUrl.isNotEmpty
              ? NetworkImage(resolvedAvatarUrl)
              : null,
          child: resolvedAvatarUrl.isEmpty
              ? Text(
                  AppStringUtils.initials(displayName),
                  style: const TextStyle(
                    color: Color(0xFF0057C8),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppDateUtils.timeAgo(createdAt),
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
        if (canEdit)
          IconButton(
            tooltip: 'Edit post',
            visualDensity: VisualDensity.compact,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
          ),
        if (canDelete)
          IconButton(
            tooltip: 'Delete post',
            visualDensity: VisualDensity.compact,
            onPressed: isDeleting ? null : onDelete,
            icon: isDeleting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                  ),
          ),
      ],
    );
  }
}
