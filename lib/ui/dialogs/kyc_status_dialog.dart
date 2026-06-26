import 'package:flutter/material.dart';

import '../widgets/buttons/button.dart';

class KycStatusDialog extends StatelessWidget {
  final bool isSuccess;
  final bool isPending;
  final bool isRejected;
  final String? rejectionReason;
  final VoidCallback onContinue;

  const KycStatusDialog({
    super.key,
    required this.isSuccess,
    required this.isPending,
    required this.isRejected,
    this.rejectionReason,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    // If it's not explicitly rejected, they are allowed to continue
    final bool canContinue = !isRejected;

    // Define visual configurations
    final String title;
    final String message;
    final Color iconColor;
    final IconData icon;

    if (isSuccess) {
      title = 'Verification Successful';
      message = 'Your documents have been successfully verified.';
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
    } else if (isPending) {
      title = 'Verification Pending';
      message = 'Your documents are currently under review. This usually takes a few minutes.';
      icon = Icons.hourglass_empty_rounded;
      iconColor = Colors.orange;
    } else if (isRejected) {
      title = 'Verification Failed';
      message = rejectionReason ?? 'An unexpected issue occurred. Please check your details and try again.';
      icon = Icons.error_outline_rounded;
      iconColor = Colors.red;
    } else {
      // Catch-all safety fallback
      title = 'Status Update';
      message = 'Processing your verification details...';
      icon = Icons.info_outline_rounded;
      iconColor = Colors.blue;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (canContinue)
          SizedBox(
            width: double.infinity,
            child: Button(
              onTap: () {
                Navigator.pop(context);
                onContinue();
              },
              text: ('Continue'),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: Button(
              onTap: () => Navigator.pop(context),
              text: ('Retry'),
            ),
          ),
      ],
    );
  }
}