import 'package:flutter/material.dart';

import '../../../../app/api_urls.dart';
import '../../../../app/app_setup_locator.dart';
import '../../../../core/enums/bottom_sheet_type.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/bottom_sheet_service.dart';
import '../../../../utils/helpers/socials_helper.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../widgets/support_category_card.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackArrowHeader(title: 'How can we help?'),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search for help topics...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF8F9FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "HELP CATEGORIES",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8F9BBA),
                  letterSpacing: 1.1,
                ),
              ),
            ),

            // Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                SupportCategoryCard(
                  icon: Icons.person_outline,
                  label: "Account & Profile",
                  iconColor: Colors.blue,
                  // onTap: () => SocialHelper.sendEmail("support@getryto.com",subject: "Account & Profile"),
                  onTap: () => sl<BottomSheetService>().showCustomBottomSheet(
                    variant: BottomSheetType.contactSupport,
                  ),
                ),
                SupportCategoryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  label: "Earnings & Payouts",
                  iconColor: Colors.green,
                  // onTap: () => SocialHelper.sendEmail("support@getryto.com", subject: "Earnings & Payouts"),
                  onTap: () => sl<BottomSheetService>().showCustomBottomSheet(
                    variant: BottomSheetType.contactSupport,
                  ),
                ),
                SupportCategoryCard(
                  icon: Icons.car_rental,
                  label: "Trip Issues",
                  iconColor: Colors.orange,
                  // onTap: () => SocialHelper.sendEmail("support@getryto.com", subject: "Trip Issues"),
                  onTap: () => sl<BottomSheetService>().showCustomBottomSheet(
                    variant: BottomSheetType.contactSupport,
                  ),
                ),
                SupportCategoryCard(
                  icon: Icons.phonelink_setup,
                  label: "App Technical Support",
                  iconColor: Colors.purple,
                  // onTap: () => SocialHelper.sendEmail("support@getryto.com", subject: "App Technical Support"),
                  onTap: () => sl<BottomSheetService>().showCustomBottomSheet(
                    variant: BottomSheetType.contactSupport,
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 32),
            // Action Tiles
            // SupportActionTile(
            //   icon: Icons.chat_bubble_outline,
            //   title: "Live Chat with Support",
            //   subtitle: "Average wait time: 2 mins",
            //   backgroundColor: const Color(0xFF0061FF),
            //   contentColor: Colors.white,
            //   onTap: () {},
            // ),
            // const SizedBox(height: 12),
            // SupportActionTile(
            //   icon: Icons.report_problem_outlined,
            //   title: "Call Emergency Support",
            //   subtitle: "Safety issues only",
            //   backgroundColor: const Color(0xFFFFF2F2),
            //   contentColor: Colors.red,
            //   showChevron: false,
            //   onTap: () {},
            // ),

            const SizedBox(height: 32),
            const Divider(),
            // Footer Links
            _buildFooterLink("FAQs", ApiUrls.faq),
            _buildFooterLink("Terms of Service", ApiUrls.terms),
            _buildFooterLink("Privacy Policy", ApiUrls.privacy),

            const SizedBox(height: 40),
            const Center(
              child: Text(
                "APP VERSION 1.0.0\n(12)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8F9BBA),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String title, String link) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF1B2559), fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () => router.push(
        Paths.WEBVIEW,
        extra: WebviewArgs(url: link, title: ""),
      ),
    );
  }
}
