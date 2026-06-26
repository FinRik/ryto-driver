import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  const SvgWidget({
    super.key,
    required this.assetName,
    this.height,
    this.width,
    this.iconColor,
  });

  final String assetName;
  final double? height, width;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      color: iconColor,
    );
  }
}
