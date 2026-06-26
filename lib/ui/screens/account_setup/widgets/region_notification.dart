import 'package:flutter/material.dart';

class RegionNotification extends StatelessWidget {
  const RegionNotification({super.key, required this.onPressed, required this.country});
  final VoidCallback onPressed;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We detected $country as you country",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Is this correct? Tap to change if needed.",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              "Change",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0066FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
