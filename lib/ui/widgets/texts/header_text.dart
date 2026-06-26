import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String label;
  final String? subText;
  final Widget? trailing;
  final TextStyle? labelStyle, subTextStyle;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final bool centerLabel, centerSubtitle;

  const HeaderText({
    super.key,
    required this.label,
    this.trailing,
    this.subText,
    this.labelStyle,
    this.subTextStyle,
    this.padding,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.centerLabel = false,
    this.centerSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 34),
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: 34),
          Text(
            label,
            textAlign: centerLabel ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ).merge(labelStyle),
          ),
          const SizedBox(height: 4),
          if (subText != null)
            Text(
              subText!,
              textAlign: centerSubtitle ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xff696E7E),
              ).merge(subTextStyle),
            ),
          // const SizedBox(height: 34),
        ],
      ),
    );
  }
}
