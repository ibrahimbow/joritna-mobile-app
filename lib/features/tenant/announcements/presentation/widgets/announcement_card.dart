import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../data/models/announcement.dart';
import 'announcement_category_chip.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final imageUrl = FileUrlResolver.resolve(announcement.imageUrl?.trim());
    final accentColor = _accentColor(announcement.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryIcon(
                  category: announcement.category,
                  color: accentColor,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            _formatTime(announcement.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              announcement.message,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade700,
              ),
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            AnnouncementCategoryChip(category: announcement.category),
          ],
        ),
      ),
    );
  }

  Color _accentColor(String category) {
    return switch (category) {
      'EMERGENCY' => Colors.red,
      'MAINTENANCE' => Colors.orange,
      'EVENT' => Colors.purple,
      'REMINDER' => Colors.blue,
      'SAFETY' => Colors.green,
      _ => Colors.blue,
    };
  }

  String _formatTime(DateTime date) {
    final localDate = date.toLocal();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, required this.color});

  final String category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      'EMERGENCY' => Icons.warning_amber_rounded,
      'MAINTENANCE' => Icons.build_rounded,
      'EVENT' => Icons.event_rounded,
      'REMINDER' => Icons.notifications_active_rounded,
      'SAFETY' => Icons.health_and_safety_rounded,
      _ => Icons.campaign_rounded,
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}
