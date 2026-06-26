import 'package:flutter/material.dart';

class CustomActionTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final Widget subtitle; // Use Widget instead of String for custom colors/tags
  final Widget trailing;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;

  const CustomActionTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            leadingIcon,
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16).merge(titleStyle),
                  ),
                  const SizedBox(height: 2),
                  subtitle,
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}