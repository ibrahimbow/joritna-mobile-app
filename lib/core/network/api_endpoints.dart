class ApiEndpoints {
  const ApiEndpoints._();

  // Authentication
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authProfile = '/auth/profile';
  static const String authChangePassword = '/auth/change-password';

  // Tenant
  static const String tenantAnnouncements = '/tenant/announcements';
  static const String tenantShareAndHelpPosts = '/tenant/share-and-help/posts';

  // Files
  static const String fileUpload = '/files/upload';
}
