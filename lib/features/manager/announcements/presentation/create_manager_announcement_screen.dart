import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/manager_announcement_providers.dart';
import '../data/models/manager_announcement.dart';
import '../data/models/requests/create_manager_announcement_request.dart';
import 'widgets/manager_announcement_form.dart';

class CreateManagerAnnouncementScreen extends ConsumerWidget {
  const CreateManagerAnnouncementScreen({super.key});

  Future<void> _createAnnouncement(
    BuildContext context,
    WidgetRef ref,
    String title,
    String message,
    AnnouncementCategory category,
    String? imageUrl,
  ) async {
    await ref
        .read(managerAnnouncementRepositoryProvider)
        .createAnnouncement(
          CreateManagerAnnouncementRequest(
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
    ).showSnackBar(const SnackBar(content: Text('Announcement created.')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Announcement')),
      body: ManagerAnnouncementForm(
        submitLabel: 'Create Announcement',
        onSubmit: (title, message, category, imageUrl) {
          return _createAnnouncement(
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
