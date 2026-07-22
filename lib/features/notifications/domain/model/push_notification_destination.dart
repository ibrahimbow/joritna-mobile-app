import 'push_notification_type.dart';

final class PushNotificationDestination {
  const PushNotificationDestination({
    required this.type,
    this.buildingId,
    this.resourceId,
  });

  final PushNotificationType type;
  final String? buildingId;
  final String? resourceId;

  bool get requiresResourceId {
    return switch (type) {
      PushNotificationType.announcement => true,
      PushNotificationType.shareAndHelp => true,
      PushNotificationType.chat => false,
      PushNotificationType.unknown => false,
    };
  }

  bool get isValid {
    if (type == PushNotificationType.unknown) {
      return false;
    }

    if (requiresResourceId) {
      return resourceId != null && resourceId!.isNotEmpty;
    }

    return true;
  }
}
