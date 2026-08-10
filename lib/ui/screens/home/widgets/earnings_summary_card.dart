import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/bottom_nav/cubit/bottom_nav_cubit.dart';
import '../../../widgets/currency_formatter_widget.dart';

class EarningsSummaryCard extends StatelessWidget {
  final String amount;
  final int tripsCompleted;
  final double? hours;

  const EarningsSummaryCard({
    super.key,
    required this.amount,
    required this.tripsCompleted,
    this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0061FF),
        borderRadius: BorderRadius.circular(20),
        // image: const DecorationImage(
        //   image: AssetImage('assets/card_mesh_pattern.png'), // Subtle background texture
        //   opacity: 0.1,
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Earnings",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  CurrencyFormatterWidget(
                    amount: amount,
                    textColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white24,
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildInfoItem("TRIPS", "$tripsCompleted Completed"),
              if(hours != null) ...[
              const SizedBox(width: 32),
              _buildInfoItem("HOURS", "${hours}h"),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.read<BottomNavCubit>().moveTo(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Details",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
