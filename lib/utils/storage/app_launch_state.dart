import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/app_string.dart';

class AppLaunchState {
  AppLaunchState._();

// Initialize the storage instance
  static final _secureStorage = const FlutterSecureStorage();

  /// Reads the launch state.
  /// Returns true if "true", false if "false", and null if the key doesn't exist.
  static Future<bool?> readLaunchState() async {
    String? value = await _secureStorage.read(key: AppString.firstLaunch);
    if (value == null) return null;
    return value == 'true';
  }

  /// Saves the launch state as a String.
  static Future<void> saveLaunchState(bool value) async {
    await _secureStorage.write(
      key: AppString.firstLaunch,
      value: value.toString(), // Converts bool to "true" or "false"
    );
  }

  static Future<bool> isFirstLaunch() async {
    // 1. You MUST 'await' the result before doing the comparison
    final storedValue = await AppLaunchState.readLaunchState();
    bool firstLaunch = storedValue == null || storedValue == true;

    if (firstLaunch) {
      await AppLaunchState.saveLaunchState(false);
    }

    return firstLaunch;
  }
}