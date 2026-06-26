import 'package:flutter/material.dart';

import '../../../app/res/images.dart';
import '../../../core/models/bookings/booking_summary.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/texts/header_text.dart';

class RequestDeclinedScreen extends StatefulWidget {
  final BookingSummary bookingSummary;

  const RequestDeclinedScreen({super.key, required this.bookingSummary});

  @override
  State<RequestDeclinedScreen> createState() => _RequestDeclinedScreenState();
}

class _RequestDeclinedScreenState extends State<RequestDeclinedScreen> {
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      bgColor: Color(0xffF9F9F9),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Success Illustration & Text
            // Replace with your specific 'Request Declined' asset
            Center(
              child: Image.asset(
                AppImages.carWash,
                height: 100,
                width: 100,
                color: Color(0xFF0061FF),
              ),
            ),
            HeaderText(
              label: "Request Declined",
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191B25),
              ),
              subText:
                  "The trip offer has been successfully\nremoved from your queue.",
              subTextStyle: TextStyle(color: Color(0xFF434656), fontSize: 16),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              centerSubtitle: true,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // 2. Reason Selection List
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "REASON FOR REJECTION (OPTIONAL)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8F9BBA),
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildReasonTile("Poor Timing", Icons.access_time),
            _buildReasonTile("Too Far Away", Icons.location_on_outlined),
            _buildReasonTile(
              "Rate Too Low",
              Icons.money_rounded,
            ),
            _buildReasonTile("Other", Icons.more_horiz),
            SizedBox(height: 104),

            // 3. Footer Action
            Button(
              onTap: () => router.go(Paths.HOME),
              text: "Return to Dashboard",
              showSuffixIcon: true,
              suffixIcon: Icons.chevron_right,
            ),
            const SizedBox(height: 8),
            const Text(
              "Your driver score will not be impacted by this choice.",
              style: TextStyle(
                color: Color(0xFF434656),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonTile(String title, IconData icon) {
    bool isSelected = selectedReason == title;
    return GestureDetector(
      onTap: () => setState(() => selectedReason = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF0061FF), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1B2559), size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B2559),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
