import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  static const String appName = 'Joritna';

  static const String _apiBaseUrlFromEnv = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String _webSocketBaseUrlFromEnv = String.fromEnvironment(
    'WEB_SOCKET_BASE_URL',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlFromEnv.isNotEmpty) {
      return _apiBaseUrlFromEnv;
    }

    assert(() {
      debugPrint(
        '⚠️ API_BASE_URL was not supplied. '
        'Using development default.',
      );
      return true;
    }());

    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    return 'http://10.0.2.2:8080/api';
  }

  static String get webSocketBaseUrl {
    if (_webSocketBaseUrlFromEnv.isNotEmpty) {
      return _webSocketBaseUrlFromEnv;
    }

    assert(() {
      debugPrint(
        '⚠️ WEB_SOCKET_BASE_URL was not supplied. '
        'Using development default.',
      );
      return true;
    }());

    if (kIsWeb) {
      return 'ws://localhost:8080';
    }

    return 'ws://10.0.2.2:8080';
  }

  static bool get isProduction =>
      !kDebugMode &&
      _apiBaseUrlFromEnv.isNotEmpty &&
      _webSocketBaseUrlFromEnv.isNotEmpty;
}
