import 'package:flutter/material.dart';

class TripInfo {
  final String title;
  final String value;
  final Alignment? alignment;

  const TripInfo({
    required this.title,
    required this.value,
    this.alignment,
  });
}

class TripInfoCard extends StatelessWidget {
  const TripInfoCard({super.key, required this.tripInfos});
  final List<TripInfo> tripInfos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Color(0xff222328),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trip stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tripInfos.map((info) {
              return Expanded(
                child: _TripInfoItem(
                  title: info.title,
                  value: info.value,
                  alignment: info.alignment ?? Alignment.centerLeft,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          const LinearProgressIndicator(value: 0.9),
        ],
      ),
    );
  }
}

class _TripInfoItem extends StatelessWidget {
  const _TripInfoItem({
    required this.title,
    required this.value,
    this.alignment = Alignment.centerLeft,
  });

  final String title;
  final String value;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == Alignment.centerLeft
          ? CrossAxisAlignment.start
          : alignment == Alignment.centerRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

