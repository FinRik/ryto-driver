import 'dart:convert';

class JwtUtils {
  JwtUtils._();
  /// Decode JWT payload
  static Map<String, dynamic>? _decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];

      // Normalize base64
      String normalized = base64Url.normalize(payload);

      final decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded);
    } catch (e) {
      return null;
    }
  }

  /// Get expiry date from token
  static DateTime? getExpiryDate(String token) {
    final payload = _decodePayload(token);
    if (payload == null || payload['exp'] == null) return null;

    final exp = payload['exp'];
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  /// Check if token is expired
  static bool isExpired(String token) {
    final expiryDate = getExpiryDate(token);
    if (expiryDate == null) return true;

    return DateTime.now().isAfter(expiryDate);
  }

  /// Validate token (not null + not expired)
  static bool isValid(String? token) {
    if (token == null || token.isEmpty) return false;

    return !isExpired(token);
  }
}