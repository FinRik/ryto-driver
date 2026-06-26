import 'package:flutter/material.dart';

class GenericDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const GenericDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onButtonPressed,
    this.buttonText = 'Okay', // Default value
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents closing via Android back button or iOS swipe gestures
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onButtonPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}