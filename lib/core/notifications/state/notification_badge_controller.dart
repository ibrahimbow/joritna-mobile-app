import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_badge_state.dart';

final class NotificationBadgeController
    extends StateNotifier<NotificationBadgeState> {
  NotificationBadgeController() : super(NotificationBadgeState());

  void addAnnouncement({required final String announcementId}) {
    final normalizedAnnouncementId = announcementId.trim();

    if (normalizedAnnouncementId.isEmpty ||
        state.newAnnouncementIds.contains(normalizedAnnouncementId)) {
      return;
    }

    final updatedIds = <String>{
      ...state.newAnnouncementIds,
      normalizedAnnouncementId,
    };

    state = state.copyWith(
      announcementUnreadCount: updatedIds.length,
      newAnnouncementIds: updatedIds,
    );
  }

  void addChatMessage() {
    state = state.copyWith(chatUnreadCount: state.chatUnreadCount + 1);
  }

  void addShareAndHelpPost({required final String postId}) {
    final normalizedPostId = postId.trim();

    if (normalizedPostId.isEmpty ||
        state.newShareAndHelpPostIds.contains(normalizedPostId)) {
      return;
    }

    final updatedIds = <String>{
      ...state.newShareAndHelpPostIds,
      normalizedPostId,
    };

    state = state.copyWith(
      shareAndHelpUnreadCount: updatedIds.length,
      newShareAndHelpPostIds: updatedIds,
    );
  }

  void markAnnouncementsAsViewed() {
    if (!state.hasUnreadAnnouncements && state.newAnnouncementIds.isEmpty) {
      return;
    }

    state = state.copyWith(
      announcementUnreadCount: 0,
      newAnnouncementIds: const <String>{},
    );
  }

  void markChatAsViewed() {
    if (!state.hasUnreadChatMessages) {
      return;
    }

    state = state.copyWith(chatUnreadCount: 0);
  }

  void markShareAndHelpAsViewed() {
    if (!state.hasUnreadShareAndHelpPosts &&
        state.newShareAndHelpPostIds.isEmpty) {
      return;
    }

    state = state.copyWith(
      shareAndHelpUnreadCount: 0,
      newShareAndHelpPostIds: const <String>{},
    );
  }

  void reset() {
    final hasNotificationState =
        state.hasUnreadAnnouncements ||
        state.hasUnreadChatMessages ||
        state.hasUnreadShareAndHelpPosts ||
        state.newAnnouncementIds.isNotEmpty ||
        state.newShareAndHelpPostIds.isNotEmpty;

    if (!hasNotificationState) {
      return;
    }

    state = NotificationBadgeState();
  }
}
