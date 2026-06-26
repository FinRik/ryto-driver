import 'package:flutter/material.dart';

import '../../../widgets/customs/custom_card_widget.dart';

class SettingsSection extends StatelessWidget {
  final String header;
  final List<Widget> tiles;

  const SettingsSection({super.key, required this.header, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      title: header.toUpperCase(),
      disableBorder: true,
      padding: EdgeInsets.zero,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8F9BBA), // Muted blue-gray
        letterSpacing: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0F2F5)),
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }
}
