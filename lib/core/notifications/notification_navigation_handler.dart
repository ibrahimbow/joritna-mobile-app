import 'dart:developer' as developer;

import 'package:go_router/go_router.dart';

import '../../features/notifications/domain/model/push_notification_payload.dart';
import '../../features/notifications/domain/service/push_notification_navigation_service.dart';

final class NotificationNavigationHandler {
  NotificationNavigationHandler({
    required GoRouter router,
    required PushNotificationNavigationService navigationService,
  }) : _router = router,
       _navigationService = navigationService;

  final GoRouter _router;
  final PushNotificationNavigationService _navigationService;

  Future<void> handle(final PushNotificationPayload payload) async {
    if (!payload.isValid) {
      developer.log(
        'Notification navigation skipped because the payload is invalid.',
        name: 'NotificationNavigationHandler',
      );

      return;
    }

    final String? route = _navigationService.buildRoute(payload);

    if (route == null || route.isEmpty) {
      developer.log(
        'Notification navigation skipped because no route could be resolved. '
        'notificationType=${payload.notificationType.name}, '
        'resourceId=${payload.resourceId}',
        name: 'NotificationNavigationHandler',
      );

      return;
    }

    try {
      _router.go(route);
    } on Object catch (exception, stackTrace) {
      developer.log(
        'Notification navigation failed. route=$route',
        name: 'NotificationNavigationHandler',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
