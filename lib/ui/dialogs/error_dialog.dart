import 'package:flutter/material.dart';

/// 1. Custom Standard Error Dialog
class CustomErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onDismiss;

  const CustomErrorDialog({
    super.key,
    required this.errorMessage,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('An Error Occurred'),
      content: Text(errorMessage, style: TextStyle(fontFamily: "Roboto"),),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}

/// 2. Custom No Internet Dialog
class NoInternetDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onRetry;

  const NoInternetDialog({
    super.key,
    required this.onCancel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.red),
          SizedBox(width: 10),
          Text('No Internet'),
        ],
      ),
      content: const Text(
        'We couldn\'t connect to the server. Please check your profile and try again.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onRetry();
          },
          child: const Text('RETRY'),
        ),
      ],
    );
  }
}

/// 3. Custom Session Expired Dialog
class SessionExpiredDialog extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const SessionExpiredDialog({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Session Expired"),
      content: const Text("Your session has timed out. Please login again to continue."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onLoginPressed();
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}