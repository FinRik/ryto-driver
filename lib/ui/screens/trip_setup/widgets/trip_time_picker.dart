import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripTimePicker extends StatelessWidget {
  final DateTime initialTime;
  final ValueChanged<DateTime> onTimeChanged;

  const TripTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Departure Time",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
        ),
        const SizedBox(height: 12),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F2F5)),
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            showTimeSeparator: true,
            initialDateTime: initialTime,
            onDateTimeChanged: onTimeChanged,
          ),
        ),
      ],
    );
  }
}