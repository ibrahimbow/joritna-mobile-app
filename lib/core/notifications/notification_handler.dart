import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../features/notifications/data/model/notification_websocket_message.dart';
import '../../features/notifications/domain/model/push_notification_payload.dart';
import '../../features/notifications/domain/model/push_notification_type.dart';
import 'notification_content_refresher.dart';
import 'notification_navigation_handler.dart';
import 'state/notification_badge_controller.dart';

final class NotificationHandler {
  NotificationHandler({
    required NotificationBadgeController badgeController,
    required NotificationNavigationHandler navigationHandler,
    required NotificationContentRefresher contentRefresher,
  }) : _badgeController = badgeController,
       _navigationHandler = navigationHandler,
       _contentRefresher = contentRefresher;

  final NotificationBadgeController _badgeController;
  final NotificationNavigationHandler _navigationHandler;
  final NotificationContentRefresher _contentRefresher;

  final Set<String> _processedNotificationIds = <String>{};

  Future<void> onForegroundMessage(final RemoteMessage message) async {
    final PushNotificationPayload? payload = _parsePayload(message);

    if (payload == null) {
      return;
    }

    final bool shouldProcess = _processBadge(payload);

    if (!shouldProcess) {
      return;
    }

    await _contentRefresher.refresh(payload);

    debugPrint(
      'Foreground notification received: '
      'firebaseMessageId=${message.messageId}, '
      'notificationId=${payload.notificationId}, '
      'type=${payload.notificationType.name}, '
      'resourceId=${payload.resourceId}',
    );
  }

  Future<void> onNotificationOpened(final RemoteMessage message) async {
    final PushNotificationPayload? payload = _parsePayload(message);

    if (payload == null) {
      return;
    }

    debugPrint(
      'Notification opened from background: '
      'firebaseMessageId=${message.messageId}, '
      'notificationId=${payload.notificationId}, '
      'type=${payload.notificationType.name}, '
      'resourceId=${payload.resourceId}',
    );

    await _navigate(payload);
  }

  Future<void> onInitialMessage(final RemoteMessage message) async {
    final PushNotificationPayload? payload = _parsePayload(message);

    if (payload == null) {
      return;
    }

    debugPrint(
      'Notification opened from terminated state: '
      'firebaseMessageId=${message.messageId}, '
      'notificationId=${payload.notificationId}, '
      'type=${payload.notificationType.name}, '
      'resourceId=${payload.resourceId}',
    );

    await _navigate(payload);
  }

  Future<void> onWebSocketMessage(final Map<String, dynamic> data) async {
    final NotificationWebSocketMessage message =
        NotificationWebSocketMessage.fromJson(data);

    if (!message.isValid) {
      debugPrint('Invalid WebSocket notification ignored: data=$data');

      return;
    }

    final PushNotificationPayload payload = message.toPushNotificationPayload();

    final bool shouldProcess = _processBadge(payload);

    if (!shouldProcess) {
      return;
    }

    await _contentRefresher.refresh(payload);

    debugPrint(
      'WebSocket notification received and content refreshed: '
      'notificationId=${payload.notificationId}, '
      'type=${payload.notificationType.name}, '
      'resourceId=${payload.resourceId}',
    );
  }

  PushNotificationPayload? _parsePayload(final RemoteMessage message) {
    final PushNotificationPayload payload = PushNotificationPayload.fromData(
      message.data,
    );

    if (!payload.isValid) {
      debugPrint(
        'Invalid push notification payload ignored: '
        'firebaseMessageId=${message.messageId}, '
        'data=${message.data}',
      );

      return null;
    }

    return payload;
  }

  bool _processBadge(final PushNotificationPayload payload) {
    if (!_shouldProcessNotification(payload)) {
      return false;
    }

    switch (payload.notificationType) {
      case PushNotificationType.announcement:
        return _addAnnouncementBadge(payload);

      case PushNotificationType.shareAndHelp:
        return _addShareAndHelpBadge(payload);

      case PushNotificationType.chat:
        _badgeController.addChatMessage();
        return true;

      case PushNotificationType.unknown:
        debugPrint('Unsupported push notification type ignored.');

        return false;
    }
  }

  bool _addAnnouncementBadge(final PushNotificationPayload payload) {
    final String announcementId = payload.resourceId?.trim() ?? '';

    if (announcementId.isEmpty) {
      debugPrint(
        'Announcement notification ignored because '
        'resourceId is missing.',
      );

      return false;
    }

    _badgeController.addAnnouncement(announcementId: announcementId);

    return true;
  }

  bool _addShareAndHelpBadge(final PushNotificationPayload payload) {
    final String postId = payload.resourceId?.trim() ?? '';

    if (postId.isEmpty) {
      debugPrint(
        'Share & Help notification ignored because '
        'resourceId is missing.',
      );

      return false;
    }

    _badgeController.addShareAndHelpPost(postId: postId);

    return true;
  }

  bool _shouldProcessNotification(final PushNotificationPayload payload) {
    final String notificationId = payload.notificationId.trim();

    if (notificationId.isEmpty) {
      debugPrint('Notification ignored because notificationId is missing.');

      return false;
    }

    final bool isNewNotification = _processedNotificationIds.add(
      notificationId,
    );

    if (!isNewNotification) {
      debugPrint(
        'Duplicate notification ignored: '
        'notificationId=$notificationId',
      );
    }

    return isNewNotification;
  }

  Future<void> _navigate(final PushNotificationPayload payload) {
    return _navigationHandler.handle(payload);
  }
}
