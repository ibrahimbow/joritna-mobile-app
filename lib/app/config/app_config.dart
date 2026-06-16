class AppConfig {
  const AppConfig._();

  static const String appName = 'Joritna';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  static const String webSocketBaseUrl = String.fromEnvironment(
    'WEB_SOCKET_BASE_URL',
    defaultValue: 'ws://localhost:8080',
  );
}