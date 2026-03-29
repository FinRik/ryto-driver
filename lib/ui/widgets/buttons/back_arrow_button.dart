import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackArrowButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconThemeData? iconTheme;
  final bool isChevron;
  final double? height, width;

  const BackArrowButton({
    super.key,
    this.onPressed,
    this.iconTheme,
    this.isChevron = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 32,
      width: width ?? 32,
      decoration: BoxDecoration(
        color: Color(0xffE7E8E9),
        border: Border.all(color: Colors.black, width: 1.5),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: onPressed ?? () => context.pop(),
        child: Icon(
          isChevron
              ? Icons.chevron_left
              : Platform.isIOS
              ? Icons.chevron_left
              : Icons.arrow_back_sharp,
          size: 18,
          color: iconTheme?.color,
        ),
      ),
    );
  }
}
