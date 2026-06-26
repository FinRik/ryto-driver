import 'package:flutter/material.dart';

class ArrivalEstimationBox extends StatelessWidget {
  final String destination;
  final String arrivalTime;

  const ArrivalEstimationBox({super.key, required this.destination, required this.arrivalTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2FF), // The same blue tint used in your route screen
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled, color: Color(0xFF0061FF)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13, height: 1.5),
                children: [
                  const TextSpan(text: "Estimated Arrival\n"),
                  const TextSpan(text: "Based on your route and typical traffic, you'll reach "),
                  TextSpan(text: destination, style: const TextStyle(color: Color(0xFF0061FF), fontWeight: FontWeight.bold)),
                  const TextSpan(text: " by "),
                  TextSpan(text: arrivalTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}