import 'package:local_auth/local_auth.dart';

class LocalAuthRepo {
  final LocalAuthentication _auth;

  LocalAuthRepo({LocalAuthentication? auth}) : _auth = auth ?? LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  /// Triggers the native platform biometric prompt
  Future<bool> authenticateUser({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        // options: const AuthenticationOptions(
        //   stickyAuth: true,
        //   biometricOnly: true,
        // ),
      );
    } catch (e) {
      // Re-throw or map to a custom exception if preferred
      rethrow;
    }
  }
}