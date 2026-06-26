import 'package:flutter/material.dart';

class MoreInfoWidget extends StatelessWidget {
  const MoreInfoWidget({
    super.key,
    required this.text,
    this.textColor,
    this.bgColor,
    this.iconColor,
    this.icon,
    this.subWidget,
    this.labelTextStyle,
  });

  final String text;
  final TextStyle? labelTextStyle;
  final Color? textColor, bgColor, iconColor;
  final IconData? icon;
  final Widget? subWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor ?? Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.info_outline,
            color: iconColor ?? Color(0xff94A3B8),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(color: textColor).merge(labelTextStyle),
                ),
                if (subWidget != null) ...[SizedBox(height: 4), ?subWidget],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
