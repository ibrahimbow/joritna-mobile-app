import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_websocket_service.dart';

final notificationWebSocketServiceProvider =
    Provider<NotificationWebSocketService>((ref) {
      return NotificationWebSocketService();
    });
