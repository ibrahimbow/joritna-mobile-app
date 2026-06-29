class RealtimeSubscription {
  const RealtimeSubscription._();

  static String buildingChatMessages(String buildingId) {
    return '/topic/buildings/$buildingId/chat/messages';
  }

  static String buildingAnnouncements(String buildingId) {
    return '/topic/buildings/$buildingId/announcements';
  }

  static String userNotifications(int userId) {
    return '/topic/users/$userId/notifications';
  }
}
