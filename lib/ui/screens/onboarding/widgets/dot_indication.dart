import 'package:flutter/material.dart';

/// ----------------------
/// REUSABLE DOT INDICATOR
/// ----------------------
class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: currentIndex != index?Colors.grey :Colors.yellowAccent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
