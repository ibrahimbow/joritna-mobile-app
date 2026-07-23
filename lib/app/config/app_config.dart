import 'package:flutter/foundation.dart';

final class AppConfig {
  const AppConfig._();

  static const String appName = 'Joritna';

  static const String _apiBaseUrlFromEnv = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String _webSocketBaseUrlFromEnv = String.fromEnvironment(
    'WEB_SOCKET_BASE_URL',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlFromEnv.trim().isNotEmpty) {
      return _removeTrailingSlash(_apiBaseUrlFromEnv.trim());
    }

    return _isWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
  }

  static String get webSocketBaseUrl {
    if (_webSocketBaseUrlFromEnv.trim().isNotEmpty) {
      return _removeTrailingSlash(_webSocketBaseUrlFromEnv.trim());
    }

    return _isWeb ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
  }

  static bool get isProduction =>
      kReleaseMode &&
      _apiBaseUrlFromEnv.trim().isNotEmpty &&
      _webSocketBaseUrlFromEnv.trim().isNotEmpty;

  static void validate() {
    if (!kReleaseMode) {
      debugPrint('Joritna is running in development mode.');
      debugPrint('API base URL: $apiBaseUrl');
      debugPrint('WebSocket base URL: $webSocketBaseUrl');

      return;
    }

    _validateRequiredConfiguration();
    _validateProductionUrl(
      name: 'API_BASE_URL',
      value: apiBaseUrl,
      requiredScheme: 'https',
    );
    _validateProductionUrl(
      name: 'WEB_SOCKET_BASE_URL',
      value: webSocketBaseUrl,
      requiredScheme: 'https',
    );
  }

  static void _validateRequiredConfiguration() {
    if (_apiBaseUrlFromEnv.trim().isEmpty) {
      throw StateError('Missing required dart-define: API_BASE_URL');
    }

    if (_webSocketBaseUrlFromEnv.trim().isEmpty) {
      throw StateError('Missing required dart-define: WEB_SOCKET_BASE_URL');
    }
  }

  static void _validateProductionUrl({
    required String name,
    required String value,
    required String requiredScheme,
  }) {
    final Uri? uri = Uri.tryParse(value);

    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('$name must be a valid absolute URL.');
    }

    if (uri.scheme.toLowerCase() != requiredScheme) {
      throw StateError('$name must use ${requiredScheme.toUpperCase()}.');
    }

    if (uri.hasQuery || uri.hasFragment) {
      throw StateError('$name must not contain query parameters or fragments.');
    }
  }

  static String _removeTrailingSlash(final String value) {
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static bool get _isWeb => kIsWeb;
}
