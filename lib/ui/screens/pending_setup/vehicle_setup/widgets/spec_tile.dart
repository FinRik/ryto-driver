import 'package:flutter/material.dart';

class SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const SpecTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFF8F9FB),
            child: Icon(icon, color: const Color(0xFF637381), size: 20),
          ),
          title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B2559))),
          trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xffF8FAFC),),
      ],
    );
  }
}