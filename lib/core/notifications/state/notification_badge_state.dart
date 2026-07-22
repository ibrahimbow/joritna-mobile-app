import 'dart:collection';

final class NotificationBadgeState {
  NotificationBadgeState({
    this.announcementUnreadCount = 0,
    this.chatUnreadCount = 0,
    this.shareAndHelpUnreadCount = 0,
    Set<String> newAnnouncementIds = const <String>{},
    Set<String> newShareAndHelpPostIds = const <String>{},
  }) : assert(announcementUnreadCount >= 0),
       assert(chatUnreadCount >= 0),
       assert(shareAndHelpUnreadCount >= 0),
       newAnnouncementIds = UnmodifiableSetView(
         Set<String>.unmodifiable(newAnnouncementIds),
       ),
       newShareAndHelpPostIds = UnmodifiableSetView(
         Set<String>.unmodifiable(newShareAndHelpPostIds),
       );

  final int announcementUnreadCount;
  final int chatUnreadCount;
  final int shareAndHelpUnreadCount;

  final Set<String> newAnnouncementIds;
  final Set<String> newShareAndHelpPostIds;

  bool get hasUnreadAnnouncements {
    return announcementUnreadCount > 0;
  }

  bool get hasUnreadChatMessages {
    return chatUnreadCount > 0;
  }

  bool get hasUnreadShareAndHelpPosts {
    return shareAndHelpUnreadCount > 0;
  }

  bool isAnnouncementNew(final String announcementId) {
    return newAnnouncementIds.contains(announcementId.trim());
  }

  bool isShareAndHelpPostNew(final String postId) {
    return newShareAndHelpPostIds.contains(postId.trim());
  }

  String formatBadgeCount(final int count) {
    if (count <= 0) {
      return '';
    }

    if (count > 9) {
      return '9+';
    }

    return count.toString();
  }

  NotificationBadgeState copyWith({
    final int? announcementUnreadCount,
    final int? chatUnreadCount,
    final int? shareAndHelpUnreadCount,
    final Set<String>? newAnnouncementIds,
    final Set<String>? newShareAndHelpPostIds,
  }) {
    return NotificationBadgeState(
      announcementUnreadCount:
          announcementUnreadCount ?? this.announcementUnreadCount,
      chatUnreadCount: chatUnreadCount ?? this.chatUnreadCount,
      shareAndHelpUnreadCount:
          shareAndHelpUnreadCount ?? this.shareAndHelpUnreadCount,
      newAnnouncementIds: newAnnouncementIds ?? this.newAnnouncementIds,
      newShareAndHelpPostIds:
          newShareAndHelpPostIds ?? this.newShareAndHelpPostIds,
    );
  }
}
