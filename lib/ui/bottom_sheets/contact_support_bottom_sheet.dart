import 'package:flutter/material.dart';

import '../../app/api_urls.dart';
import '../../app/app_setup_locator.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../../core/setups/region_identity_setup.dart';
import '../../utils/helpers/call_service_util.dart';
import '../../utils/helpers/socials_helper.dart';
import '../screens/profile/widgets/support_action_tile.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class ContactSupportBottomSheet extends StatelessWidget {
  const ContactSupportBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  Widget build(BuildContext context) {
    final region = sl<RegionIdentity>();

    return BaseBottomSheet(
      showHandleBar: true,
      multiplier: .55,
      builder: (context, size) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Contact Support",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Reach the Ryto ${region.country} support team",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          SupportActionTile(
            icon: Icons.chat_bubble_rounded,
            title: "WhatsApp",
            subtitle: region.supportPhone,
            backgroundColor: const Color(0xFFE8F9EF),
            contentColor: const Color(0xFF25D366),
            onTap: () {
              completer(SheetResponse(confirmed: true));
              SocialHelper.openWhatsApp(region.supportWhatsappLink);
            },
          ),
          const SizedBox(height: 12),
          SupportActionTile(
            icon: Icons.call_rounded,
            title: "Call Support",
            subtitle: region.supportPhone,
            backgroundColor: const Color(0xFFE6EFFD),
            contentColor: const Color(0xFF0060EB),
            onTap: () {
              completer(SheetResponse(confirmed: true));
              CallServiceUtil.makePhoneCall(region.supportPhone);
            },
          ),
          const SizedBox(height: 12),
          SupportActionTile(
            icon: Icons.email_rounded,
            title: "Email Support",
            subtitle: ApiUrls.supportEmail,
            backgroundColor: const Color(0xFFF3EEFF),
            contentColor: const Color(0xFF7B4DFF),
            onTap: () {
              completer(SheetResponse(confirmed: true));
              SocialHelper.sendEmail(
                ApiUrls.supportEmail,
                subject: "Support Request",
              );
            },
          ),
        ],
      ),
    );
  }
}
