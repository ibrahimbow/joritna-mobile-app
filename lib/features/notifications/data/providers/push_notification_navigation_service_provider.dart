import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/service/push_notification_navigation_service.dart';

final pushNotificationNavigationServiceProvider =
    Provider<PushNotificationNavigationService>((ref) {
      return const PushNotificationNavigationService();
    });
