import 'package:url_launcher/url_launcher.dart';

import '../../app/api_urls.dart';

class SocialHelper {
  SocialHelper._();

  static Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      print('Error launching social link: $e');
    }
  }

  // Pre-defined social methods
  static Future<void> openTwitter() => _launchUrl(ApiUrls.twitter);

  static Future<void> openLinkedIn() => _launchUrl(ApiUrls.linkedIn);

  static Future<void> openInstagram() => _launchUrl(ApiUrls.instagram);

  static Future<void> sendEmail(String email, {String subject = ''}) =>
      _launchUrl('mailto:$email?subject=${Uri.encodeComponent(subject)}');

  static Future<void> openWhatsApp(String link) => _launchUrl(link);
}
