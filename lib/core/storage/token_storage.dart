import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) {
    return _storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<void> clearAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }
}