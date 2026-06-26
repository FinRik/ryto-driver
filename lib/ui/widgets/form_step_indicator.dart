import 'package:flutter/material.dart';

class FormStepIndicator extends StatelessWidget {
  const FormStepIndicator({super.key, required this.length, required this.index});

  final String length, index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        "Step $index of $length",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
