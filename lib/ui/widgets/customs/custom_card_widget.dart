import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/app_decorations.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.title,
    this.titleStyle,
    this.bgColor,
    this.border,
    required this.child,
    this.icon,
    this.iconColor,
    this.bottomMargin, this.disableBorder = false,
    this.padding,
  });

  final String title;
  final TextStyle? titleStyle;
  final Color? bgColor;
  final BoxBorder? border;
  final Widget child;
  final String? icon;
  final Color? iconColor;
  final EdgeInsets? padding;
  final double? bottomMargin;
  final bool disableBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
        color: bgColor,
        border: disableBorder ? BoxBorder.all(style: BorderStyle.none):border,
      ),
      padding: padding ?? EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: bottomMargin ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16).merge(titleStyle),
              ),
              if (icon != null) SvgPicture.asset(icon!, color: iconColor),
            ],
          ),
          SizedBox(height: 16),
          Container(child: child),
        ],
      ),
    );
  }
}
