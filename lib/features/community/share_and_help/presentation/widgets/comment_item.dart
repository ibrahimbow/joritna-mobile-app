import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/string_utils.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
    required this.text,
    required this.canDelete,
    required this.onDelete,
  });

  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final String text;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final resolvedAvatarUrl = FileUrlResolver.resolve(avatarUrl);
    final safeDisplayName = displayName.trim().isEmpty
        ? 'Resident'
        : displayName.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFE6EFFD),
            backgroundImage: resolvedAvatarUrl.isNotEmpty
                ? NetworkImage(resolvedAvatarUrl)
                : null,
            child: resolvedAvatarUrl.isEmpty
                ? Text(
                    AppStringUtils.initials(safeDisplayName),
                    style: const TextStyle(
                      color: Color(0xFF0057C8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 8, 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          runSpacing: 1,
                          children: [
                            Text(
                              safeDisplayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppDateUtils.timeAgo(createdAt),
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (canDelete)
                        IconButton(
                          tooltip: 'Delete comment',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 26,
                            minHeight: 26,
                          ),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                            color: Color(0xFFDC2626),
                          ),
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    text.trim(),
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}