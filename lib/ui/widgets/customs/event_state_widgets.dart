import 'package:flutter/material.dart';

import '../../../app/res/icons.dart';
import '../../../app/res/images.dart';
import '../../styles/app_decorations.dart';
import '../buttons/button.dart';
import '../texts/header_text.dart';
import 'svg_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.btnText,
    this.onTap,
  });

  final String title;
  final String? subtitle, btnText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE7E8E9)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 24),
          child: Column(
            children: [
              Image.asset(AppImages.car, height: 100),
              HeaderText(
                padding: const EdgeInsets.symmetric(vertical: 8),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                label: "No drivers available yet?",
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                subText: "Turn on alerts and we’ll notify you soon.",
                subTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                centerSubtitle: true,
              ),
              if (onTap != null) ...[
                SizedBox(height: 34),
                Button(text: btnText ?? "Ok", onTap: () => onTap!.call()),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    this.title,
    this.message,
    required this.onRetry,
  });

  final String? title, message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
            color: Colors.white,
            border: Border.all(color: const Color(0xffE7E8E9)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 24),
          child: Column(
            children: [
              SvgWidget(
                assetName: AppIcons.warning,
                height: 80,
                iconColor: Colors.red.withOpacity(.8),
              ),
              HeaderText(
                padding: const EdgeInsets.symmetric(vertical: 8),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                label: title ?? "Error Occurred",
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red.withOpacity(.6),
                ),
                subText: message,
                subTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.withOpacity(.6),
                ),
                centerSubtitle: true,
              ),
              SizedBox(height: 34),
              Button(text: "Retry", onTap: () => onRetry.call()),
            ],
          ),
        ),
      ],
    );
  }
}
