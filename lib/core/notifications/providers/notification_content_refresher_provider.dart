import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notification_content_refresher.dart';

final notificationContentRefresherProvider =
    Provider<NotificationContentRefresher>((final Ref ref) {
      return NotificationContentRefresher(ref: ref);
    });
