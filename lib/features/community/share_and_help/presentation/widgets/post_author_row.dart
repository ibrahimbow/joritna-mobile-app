import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/string_utils.dart';

enum PostAuthorAction { toggleStatus, edit, delete }

class PostAuthorRow extends StatelessWidget {
  const PostAuthorRow({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
    required this.isOwner,
    required this.isResolved,
    required this.isUpdatingStatus,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  final bool isOwner;
  final bool isResolved;
  final bool isUpdatingStatus;
  final bool isDeleting;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

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
              Row(
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (isResolved) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF16A34A),
                            size: 13,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Resolved',
                            style: TextStyle(
                              color: Color(0xFF166534),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                AppDateUtils.timeAgo(createdAt),
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ),
        if (isOwner)
          PopupMenuButton<PostAuthorAction>(
            tooltip: 'Post actions',
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF475569)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (action) {
              switch (action) {
                case PostAuthorAction.toggleStatus:
                  onToggleStatus();
                case PostAuthorAction.edit:
                  onEdit();
                case PostAuthorAction.delete:
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: PostAuthorAction.toggleStatus,
                enabled: !isUpdatingStatus,
                child: _PostActionMenuItem(
                  icon: isResolved
                      ? Icons.lock_open_rounded
                      : Icons.check_circle_rounded,
                  label: isResolved ? 'Reopen' : 'Mark as resolved',
                  color: const Color(0xFF2563EB),
                  isLoading: isUpdatingStatus,
                ),
              ),
              const PopupMenuItem(
                value: PostAuthorAction.edit,
                child: _PostActionMenuItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Color(0xFF2563EB),
                ),
              ),
              PopupMenuItem(
                value: PostAuthorAction.delete,
                enabled: !isDeleting,
                child: _PostActionMenuItem(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  color: const Color(0xFFDC2626),
                  isLoading: isDeleting,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PostActionMenuItem extends StatelessWidget {
  const _PostActionMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          )
        else
          Icon(icon, color: color, size: 21),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
