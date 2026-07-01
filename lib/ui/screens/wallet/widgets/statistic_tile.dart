import 'package:flutter/material.dart';

import '../../../widgets/currency_formatter_widget.dart';

class StatisticTile extends StatelessWidget {
  final String currency;
  final String label;
  final String value;
  final Color valueColor;

  const StatisticTile({
    super.key,
    required this.currency,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1B2559),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF637381),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          CurrencyFormatterWidget(
            amount: value,
            style: TextStyle(
              fontFamily: "Roboto",
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
