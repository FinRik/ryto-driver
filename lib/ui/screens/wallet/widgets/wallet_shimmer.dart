import 'package:flutter/material.dart';

import '../../../widgets/loaders/loading_shimmer.dart';

class WalletCardShimmer extends StatelessWidget {
  const WalletCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Column(
        children: [
          // Main Balance Card Placeholder
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          // Stats Row Placeholder
          Row(
            children: [
              Expanded(child: _buildBox(70)),
              const SizedBox(width: 12),
              Expanded(child: _buildBox(70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBox(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class TransactionTileShimmer extends StatelessWidget {
  const TransactionTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Icon Placeholder
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Text Column Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 120, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(height: 10, width: 80, color: Colors.white),
                ],
              ),
            ),
            // Amount Placeholder
            Container(height: 14, width: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }
}