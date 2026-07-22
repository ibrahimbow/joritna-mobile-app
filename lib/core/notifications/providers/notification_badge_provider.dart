import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/notification_badge_controller.dart';
import '../state/notification_badge_state.dart';

final notificationBadgeProvider =
    StateNotifierProvider<NotificationBadgeController, NotificationBadgeState>((
      ref,
    ) {
      return NotificationBadgeController();
    });
