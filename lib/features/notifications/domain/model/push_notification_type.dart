enum PushNotificationType {
  announcement,
  shareAndHelp,
  chat,
  unknown;

  static PushNotificationType fromValue(final String value) {
    switch (value.trim().toUpperCase()) {
      case 'ANNOUNCEMENT':
        return PushNotificationType.announcement;

      case 'SHARE_AND_HELP':
        return PushNotificationType.shareAndHelp;

      case 'CHAT':
        return PushNotificationType.chat;

      default:
        return PushNotificationType.unknown;
    }
  }
}
