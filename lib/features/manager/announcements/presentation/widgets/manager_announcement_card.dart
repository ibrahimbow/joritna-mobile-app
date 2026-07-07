import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../data/models/manager_announcement.dart';

class ManagerAnnouncementCard extends StatelessWidget {
  final ManagerAnnouncement announcement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ManagerAnnouncementCard({
    super.key,
    required this.announcement,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = FileUrlResolver.resolve(announcement.imageUrl);
    final categoryStyle = _categoryStyle(announcement.category);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: categoryStyle.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  categoryStyle.icon,
                  color: categoryStyle.foregroundColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _announcementDateText(announcement),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
                color: const Color(0xFF2563EB),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: const Color(0xFFEF4444),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            announcement.message,
            style: const TextStyle(
              fontSize: 15.5,
              height: 1.55,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (imageUrl.isNotEmpty) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFF1F5F9),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Color(0xFF94A3B8),
                        size: 36,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: categoryStyle.badgeColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryStyle.icon,
                  size: 16,
                  color: categoryStyle.badgeTextColor,
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.category.label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: categoryStyle.badgeTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _announcementDateText(ManagerAnnouncement announcement) {
    final updatedAt = announcement.updatedAt;

    if (updatedAt != null && updatedAt != announcement.createdAt) {
      return ' ${AppDateUtils.timeAgo(announcement.createdAt)} • Edited ${AppDateUtils.timeAgo(updatedAt)}';
    }

    return ' ${AppDateUtils.timeAgo(announcement.createdAt)}';
  }
}

class _AnnouncementCategoryStyle {
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color badgeColor;
  final Color badgeTextColor;

  const _AnnouncementCategoryStyle({
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.badgeColor,
    required this.badgeTextColor,
  });
}

_AnnouncementCategoryStyle _categoryStyle(AnnouncementCategory category) {
  switch (category) {
    case AnnouncementCategory.general:
      return const _AnnouncementCategoryStyle(
        icon: Icons.campaign_rounded,
        foregroundColor: Color(0xFF2563EB),
        backgroundColor: Color(0xFFEFF6FF),
        badgeColor: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF1D4ED8),
      );

    case AnnouncementCategory.maintenance:
      return const _AnnouncementCategoryStyle(
        icon: Icons.build_rounded,
        foregroundColor: Color(0xFF2563EB),
        backgroundColor: Color(0xFFEFF6FF),
        badgeColor: Color(0xFFFEF3C7),
        badgeTextColor: Color(0xFFB45309),
      );

    case AnnouncementCategory.emergency:
      return const _AnnouncementCategoryStyle(
        icon: Icons.warning_amber_rounded,
        foregroundColor: Color(0xFFDC2626),
        backgroundColor: Color(0xFFFEF2F2),
        badgeColor: Color(0xFFFEE2E2),
        badgeTextColor: Color(0xFFB91C1C),
      );

    case AnnouncementCategory.event:
      return const _AnnouncementCategoryStyle(
        icon: Icons.event_rounded,
        foregroundColor: Color(0xFF7C3AED),
        backgroundColor: Color(0xFFF5F3FF),
        badgeColor: Color(0xFFF3E8FF),
        badgeTextColor: Color(0xFF6D28D9),
      );

    case AnnouncementCategory.reminder:
      return const _AnnouncementCategoryStyle(
        icon: Icons.notifications_active_rounded,
        foregroundColor: Color(0xFF0891B2),
        backgroundColor: Color(0xFFECFEFF),
        badgeColor: Color(0xFFCFFAFE),
        badgeTextColor: Color(0xFF0E7490),
      );

    case AnnouncementCategory.safety:
      return const _AnnouncementCategoryStyle(
        icon: Icons.health_and_safety_rounded,
        foregroundColor: Color(0xFF16A34A),
        backgroundColor: Color(0xFFF0FDF4),
        badgeColor: Color(0xFFDCFCE7),
        badgeTextColor: Color(0xFF15803D),
      );
  }
}
