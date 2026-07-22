import '../../../../app/router/app_routes.dart';
import '../model/push_notification_payload.dart';
import '../model/push_notification_type.dart';

final class PushNotificationNavigationService {
  const PushNotificationNavigationService();

  String? buildRoute(final PushNotificationPayload payload) {
    if (!payload.isValid) {
      return null;
    }

    switch (payload.notificationType) {
      case PushNotificationType.announcement:
        return AppRoutes.tenantAnnouncements;

      case PushNotificationType.shareAndHelp:
        return AppRoutes.tenantShareAndHelp;

      case PushNotificationType.chat:
        return AppRoutes.tenantChat;

      case PushNotificationType.unknown:
        return null;
    }
  }
}
