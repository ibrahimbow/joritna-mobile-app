import 'package:flutter/material.dart';

import '../../../../../core/file/file_url_resolver.dart';
import '../../data/models/announcement.dart';
import 'announcement_category_chip.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.isNew = false,
  });

  final Announcement announcement;
  final bool isNew;

  @override
  Widget build(final BuildContext context) {
    final String imageUrl = FileUrlResolver.resolve(
      announcement.imageUrl?.trim(),
    );

    final Color accentColor = _resolveAccentColor(announcement.category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNew ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnnouncementHeader(
              announcement: announcement,
              accentColor: accentColor,
              isNew: isNew,
            ),
            const SizedBox(height: 16),
            Text(
              announcement.message.trim(),
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: 14),
              _AnnouncementImage(
                key: ValueKey<String>(imageUrl),
                imageUrl: imageUrl,
              ),
            ],
            const SizedBox(height: 16),
            AnnouncementCategoryChip(category: announcement.category),
          ],
        ),
      ),
    );
  }

  Color _resolveAccentColor(final String category) {
    return switch (category.trim().toUpperCase()) {
      'EMERGENCY' => Colors.red,
      'MAINTENANCE' => Colors.orange,
      'EVENT' => Colors.purple,
      'REMINDER' => Colors.blue,
      'SAFETY' => Colors.green,
      _ => Colors.blue,
    };
  }
}

final class _AnnouncementHeader extends StatelessWidget {
  const _AnnouncementHeader({
    required this.announcement,
    required this.accentColor,
    required this.isNew,
  });

  final Announcement announcement;
  final Color accentColor;
  final bool isNew;

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CategoryIcon(category: announcement.category, color: accentColor),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      announcement.title.trim(),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ),
                  if (isNew) ...[const SizedBox(width: 10), const _NewBadge()],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _formatTime(announcement.createdAt),
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(final DateTime date) {
    final DateTime localDate = date.toLocal();

    final String hour = localDate.hour.toString().padLeft(2, '0');

    final String minute = localDate.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

final class _AnnouncementImage extends StatefulWidget {
  const _AnnouncementImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<_AnnouncementImage> createState() => _AnnouncementImageState();
}

final class _AnnouncementImageState extends State<_AnnouncementImage> {
  bool _hasFailed = false;

  @override
  void didUpdateWidget(covariant final _AnnouncementImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrl != widget.imageUrl) {
      _hasFailed = false;
    }
  }

  @override
  Widget build(final BuildContext context) {
    if (_hasFailed) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        widget.imageUrl,
        width: double.infinity,
        height: 170,
        fit: BoxFit.cover,
        frameBuilder:
            (
              final BuildContext context,
              final Widget child,
              final int? frame,
              final bool wasSynchronouslyLoaded,
            ) {
              if (wasSynchronouslyLoaded || frame != null) {
                return AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 200),
                  child: child,
                );
              }

              return const SizedBox(
                height: 170,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
        errorBuilder:
            (
              final BuildContext context,
              final Object error,
              final StackTrace? stackTrace,
            ) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted || _hasFailed) {
                  return;
                }

                setState(() {
                  _hasFailed = true;
                });
              });

              return const SizedBox.shrink();
            },
      ),
    );
  }
}

final class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'New',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

final class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, required this.color});

  final String category;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    final IconData icon = switch (category.trim().toUpperCase()) {
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
