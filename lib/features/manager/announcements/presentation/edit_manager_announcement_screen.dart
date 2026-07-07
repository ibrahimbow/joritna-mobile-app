import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/manager_announcement_providers.dart';
import '../data/models/manager_announcement.dart';
import '../data/models/requests/update_manager_announcement_request.dart';
import 'widgets/manager_announcement_form.dart';

class EditManagerAnnouncementScreen extends ConsumerWidget {
  final ManagerAnnouncement announcement;

  const EditManagerAnnouncementScreen({super.key, required this.announcement});

  Future<void> _updateAnnouncement(
    BuildContext context,
    WidgetRef ref,
    String title,
    String message,
    AnnouncementCategory category,
    String? imageUrl,
  ) async {
    await ref
        .read(managerAnnouncementRepositoryProvider)
        .updateAnnouncement(
          announcement.id,
          UpdateManagerAnnouncementRequest(
            title: title,
            message: message,
            category: category,
            imageUrl: imageUrl,
          ),
        );

    ref.invalidate(managerAnnouncementsProvider);

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Announcement updated.')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Announcement')),
      body: ManagerAnnouncementForm(
        submitLabel: 'Update Announcement',
        initialAnnouncement: announcement,
        onSubmit: (title, message, category, imageUrl) {
          return _updateAnnouncement(
            context,
            ref,
            title,
            message,
            category,
            imageUrl,
          );
        },
      ),
    );
  }
}
