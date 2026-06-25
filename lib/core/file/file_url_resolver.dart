import '../../app/config/app_config.dart';

class FileUrlResolver {
  const FileUrlResolver._();

  static String resolve(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.startsWith('http://') ||
        trimmedValue.startsWith('https://')) {
      return trimmedValue;
    }

    final apiBaseUri = Uri.parse(AppConfig.apiBaseUrl);
    final origin = '${apiBaseUri.scheme}://${apiBaseUri.authority}';

    if (trimmedValue.startsWith('/api/')) {
      return '$origin$trimmedValue';
    }

    if (trimmedValue.startsWith('/')) {
      return '${AppConfig.apiBaseUrl}$trimmedValue';
    }

    return '${AppConfig.apiBaseUrl}/$trimmedValue';
  }
}
