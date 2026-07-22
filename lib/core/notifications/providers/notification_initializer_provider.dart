import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/notifications/data/datasource/remote/notification_websocket_service_provider.dart';
import '../notification_handler.dart';
import '../notification_initializer.dart';
import 'firebase_messaging_provider.dart';
import 'notification_badge_provider.dart';
import 'notification_content_refresher_provider.dart';
import 'notification_navigation_handler_provider.dart';
import 'push_device_registration_service_provider.dart';

final notificationHandlerProvider = Provider<NotificationHandler>((
  final Ref ref,
) {
  return NotificationHandler(
    badgeController: ref.read(notificationBadgeProvider.notifier),
    navigationHandler: ref.watch(notificationNavigationHandlerProvider),
    contentRefresher: ref.watch(notificationContentRefresherProvider),
  );
});

final notificationInitializerProvider = Provider<NotificationInitializer>((
  final Ref ref,
) {
  final NotificationInitializer initializer = NotificationInitializer(
    firebaseMessagingService: ref.watch(firebaseMessagingServiceProvider),
    pushDeviceRegistrationService: ref.watch(
      pushDeviceRegistrationServiceProvider,
    ),
    notificationWebSocketService: ref.watch(
      notificationWebSocketServiceProvider,
    ),
    notificationHandler: ref.watch(notificationHandlerProvider),
  );

  ref.onDispose(() {
    unawaited(initializer.dispose());
  });

  return initializer;
});
