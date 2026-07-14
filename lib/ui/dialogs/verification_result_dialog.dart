import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationResultDialog extends StatelessWidget {
  const VerificationResultDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
    this.onDismiss,
  });

  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback? onDismiss;

  /// Static helper method to cleanly present this dialog from anywhere
  static void show(
      BuildContext context, {
        required String title,
        required String message,
        required bool isSuccess,
        VoidCallback? onDismiss,
      }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => VerificationResultDialog(
        title: title,
        message: message,
        isSuccess: isSuccess,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: isSuccess ? Colors.green : Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("Dismiss"),
          onPressed: () {
            Navigator.of(context).pop();
            if (onDismiss != null) {
              onDismiss!();
            }
          },
        ),
      ],
    );
  }
}