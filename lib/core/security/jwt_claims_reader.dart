import 'dart:convert';

class JwtClaimsReader {
  const JwtClaimsReader();

  Map<String, dynamic> readClaims(String token) {
    final parts = token.split('.');

    if (parts.length != 3) {
      return const {};
    }

    final payload = parts[1];
    final normalizedPayload = base64Url.normalize(payload);
    final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

    final json = jsonDecode(decodedPayload);

    if (json is Map<String, dynamic>) {
      return json;
    }

    return const {};
  }

  String? readRole(String token) {
    final claims = readClaims(token);

    final role = claims['role'] ?? claims['authorities'] ?? claims['scope'];

    if (role == null) {
      return null;
    }

    if (role is String) {
      return role.replaceAll('ROLE_', '').toUpperCase();
    }

    if (role is List && role.isNotEmpty) {
      return role.first.toString().replaceAll('ROLE_', '').toUpperCase();
    }

    return null;
  }
}
