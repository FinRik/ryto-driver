import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/app_string.dart';

class TokenStorage {
  TokenStorage._();

  static final _localStorageService = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    return await _localStorageService.read(key: AppString.accessToken);
  }

  static Future<void> saveAccessToken(String token) async {
    return await _localStorageService.write(
      key: AppString.accessToken,
      value: token,
    );
  }

  static Future<bool> deleteAccessToken() async {
    try {
      await _localStorageService.delete(key: AppString.accessToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}
