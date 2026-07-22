class ApiEndpoints {
  const ApiEndpoints._();

  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authProfile = '/auth/profile';
  static const String authChangePassword = '/auth/change-password';

  static const String tenantBuildings = '/tenant/buildings';
  static const String tenantAnnouncements = '/tenant/announcements';
  static const String tenantShareAndHelpPosts = '/tenant/share-and-help/posts';
  static const String tenantChatMessages = '/tenant/chat/messages';

  static const String managerBuildings = '/manager/buildings';
  static const String managerAnnouncements = '/manager/announcements';

  static const String fileUpload = '/files/upload';

  static const String pushDevices = '/notifications/push-devices';
}
