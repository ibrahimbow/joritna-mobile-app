import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(
      key: _accessTokenKey,
    );
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(
      key: _accessTokenKey,
    );

    await _secureStorage.delete(
      key: _refreshTokenKey,
    );
  }
}