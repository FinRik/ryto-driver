import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Shimmer for HeaderText
          Center(
            child: Column(
              children: [
                Container(width: 200, height: 24, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 250, height: 14, color: Colors.white),
                const SizedBox(height: 4),
                Container(width: 180, height: 14, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Shimmer for VerificationCards
          _shimmerCard(),
          const SizedBox(height: 16),
          _shimmerCard(),
        ],
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}


class ShimmerLoader extends StatelessWidget {
  final Widget child;
  const ShimmerLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}