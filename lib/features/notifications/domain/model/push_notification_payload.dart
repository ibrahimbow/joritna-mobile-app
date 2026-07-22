import 'push_notification_destination.dart';
import 'push_notification_type.dart';

final class PushNotificationPayload {
  const PushNotificationPayload({
    required this.notificationId,
    required this.notificationType,
    this.buildingId,
    this.resourceId,
  });

  final String notificationId;
  final PushNotificationType notificationType;
  final String? buildingId;
  final String? resourceId;

  factory PushNotificationPayload.fromData(final Map<String, dynamic> data) {
    return PushNotificationPayload(
      notificationId: _readRequiredValue(data, 'notificationId'),
      notificationType: PushNotificationType.fromValue(
        _readRequiredValue(data, 'notificationType'),
      ),
      buildingId: _readOptionalValue(data, 'buildingId'),
      resourceId: _readOptionalValue(data, 'resourceId'),
    );
  }

  bool get isValid {
    if (notificationId.isEmpty ||
        notificationType == PushNotificationType.unknown) {
      return false;
    }

    return switch (notificationType) {
      PushNotificationType.announcement || PushNotificationType.shareAndHelp =>
        resourceId != null && resourceId!.isNotEmpty,
      PushNotificationType.chat => true,
      PushNotificationType.unknown => false,
    };
  }

  PushNotificationDestination toDestination() {
    return PushNotificationDestination(
      type: notificationType,
      buildingId: buildingId,
      resourceId: resourceId,
    );
  }

  static String _readRequiredValue(
    final Map<String, dynamic> data,
    final String key,
  ) {
    return data[key]?.toString().trim() ?? '';
  }

  static String? _readOptionalValue(
    final Map<String, dynamic> data,
    final String key,
  ) {
    final String? value = data[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }
}
