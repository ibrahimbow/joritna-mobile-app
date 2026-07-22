import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tenant/announcements/data/announcement_providers.dart';
import '../../features/notifications/domain/model/push_notification_payload.dart';
import '../../features/notifications/domain/model/push_notification_type.dart';
import '../../features/community/share_and_help/data/share_and_help_providers.dart';

final class NotificationContentRefresher {
  NotificationContentRefresher({required Ref ref}) : _ref = ref;

  final Ref _ref;

  Future<void> refresh(final PushNotificationPayload payload) async {
    switch (payload.notificationType) {
      case PushNotificationType.announcement:
        await _refreshAnnouncements();
        return;

      case PushNotificationType.shareAndHelp:
        await _refreshShareAndHelp();
        return;

      case PushNotificationType.chat:
      case PushNotificationType.unknown:
        return;
    }
  }

  Future<void> _refreshAnnouncements() async {
    try {
      final result = await _ref.refresh(tenantAnnouncementsProvider.future);

      debugPrint(
        'Announcements refreshed after notification. '
        'count=${result.length}',
      );
    } catch (error, stackTrace) {
      debugPrint('Could not refresh announcements after notification: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _refreshShareAndHelp() async {
    try {
      final result = await _ref.refresh(shareAndHelpPostsProvider.future);

      debugPrint(
        'Share & Help refreshed after notification. '
        'count=${result.length}',
      );
    } catch (error, stackTrace) {
      debugPrint('Could not refresh Share & Help after notification: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
