import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/app_string.dart';

class FcmTokenStorage {
  FcmTokenStorage._();

  static final _localStorageService = FlutterSecureStorage();

  static Future<String?> getFCMToken() async {
    return await _localStorageService.read(key: AppString.fcmToken);
  }

  static Future<void> saveFCMToken(String token) async {
    return await _localStorageService.write(
      key: AppString.fcmToken,
      value: token,
    );
  }

  static Future<bool> deleteFCMToken() async {
    try {
      await _localStorageService.delete(key: AppString.fcmToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}
