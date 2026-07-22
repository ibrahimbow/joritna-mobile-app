import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../features/notifications/data/providers/push_notification_navigation_service_provider.dart';
import '../notification_navigation_handler.dart';

final notificationNavigationHandlerProvider =
    Provider<NotificationNavigationHandler>((ref) {
      final GoRouter router = ref.watch(appRouterProvider);

      final navigationService = ref.watch(
        pushNotificationNavigationServiceProvider,
      );

      return NotificationNavigationHandler(
        router: router,
        navigationService: navigationService,
      );
    });
