class AppStringUtils {
  const AppStringUtils._();

  static String initials(
    String displayName,
  ) {
    final parts = displayName
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  static bool isBlank(
    String? value,
  ) {
    return value == null || value.trim().isEmpty;
  }
}