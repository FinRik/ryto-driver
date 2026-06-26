  import 'package:url_launcher/url_launcher.dart';

class CallServiceUtil {
  CallServiceUtil._();

  static String maskPhoneNumber(String phone, {int visibleDigits = 4}) {
    if (phone.length <= visibleDigits) return phone;

    final visiblePart = phone.substring(0, visibleDigits);
    final maskedPart = '*' * (phone.length - visibleDigits);

    return '$visiblePart$maskedPart';
  }


  /// Launches the phone dialer with the given number (does NOT auto-call for safety)
  static Future<void> makePhoneCall(String phoneNumber) async {
    // Clean the phone number (remove spaces, dashes, etc.)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+()]'), '');

    final Uri uri = Uri(
      scheme: 'tel',
      path: cleanNumber,
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens native Phone app
        );
      } else {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      // Handle error (e.g., show SnackBar)
      print('Error launching call: $e');
      // You can rethrow or show a user-friendly message
    }
  }
}