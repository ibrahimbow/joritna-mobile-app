import '../../domain/model/push_notification_payload.dart';
import '../../domain/model/push_notification_type.dart';

final class NotificationWebSocketMessage {
  const NotificationWebSocketMessage({
    required this.id,
    required this.userId,
    required this.buildingId,
    required this.type,
    required this.resourceId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.readAt,
  });

  final String id;
  final int userId;
  final String buildingId;
  final PushNotificationType type;
  final String? resourceId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? readAt;

  factory NotificationWebSocketMessage.fromJson(
    final Map<String, dynamic> json,
  ) {
    return NotificationWebSocketMessage(
      id: _readRequiredString(json, 'id'),
      userId: _readRequiredInt(json, 'userId'),
      buildingId: _readRequiredString(json, 'buildingId'),
      type: PushNotificationType.fromValue(_readRequiredString(json, 'type')),
      resourceId: _readOptionalString(json, 'resourceId'),
      title: _readRequiredString(json, 'title'),
      message: _readRequiredString(json, 'message'),
      isRead: _readBool(json, 'read'),
      createdAt: _readDateTime(json, 'createdAt'),
      readAt: _readDateTime(json, 'readAt'),
    );
  }

  bool get isValid {
    if (id.isEmpty ||
        userId <= 0 ||
        buildingId.isEmpty ||
        type == PushNotificationType.unknown) {
      return false;
    }

    return switch (type) {
      PushNotificationType.announcement || PushNotificationType.shareAndHelp =>
        resourceId != null && resourceId!.isNotEmpty,
      PushNotificationType.chat => true,
      PushNotificationType.unknown => false,
    };
  }

  PushNotificationPayload toPushNotificationPayload() {
    return PushNotificationPayload(
      notificationId: id,
      notificationType: type,
      buildingId: buildingId,
      resourceId: resourceId,
    );
  }

  static String _readRequiredString(
    final Map<String, dynamic> json,
    final String key,
  ) {
    return json[key]?.toString().trim() ?? '';
  }

  static String? _readOptionalString(
    final Map<String, dynamic> json,
    final String key,
  ) {
    final value = json[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  static int _readRequiredInt(
    final Map<String, dynamic> json,
    final String key,
  ) {
    final value = json[key];

    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _readBool(final Map<String, dynamic> json, final String key) {
    final value = json[key];

    if (value is bool) {
      return value;
    }

    return value?.toString().toLowerCase() == 'true';
  }

  static DateTime? _readDateTime(
    final Map<String, dynamic> json,
    final String key,
  ) {
    final value = json[key]?.toString().trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
