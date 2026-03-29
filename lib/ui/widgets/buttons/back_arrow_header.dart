import 'package:flutter/material.dart';

import '../texts/header_text.dart';
import 'back_arrow_button.dart';

class BackArrowHeader extends StatelessWidget {
  const BackArrowHeader({
    super.key,
    required this.title,
    this.subText,
    this.setDefaultPadding = false,
    this.onPressed,
  });

  final String title;
  final String? subText;
  final bool setDefaultPadding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackArrowButton(isChevron: false, onPressed: onPressed),
        SizedBox(height: 19),
        HeaderText(
          label: title,
          subText: subText,
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          padding: setDefaultPadding
              ? const EdgeInsets.symmetric(vertical: 34)
              : EdgeInsets.zero,
        ),
      ],
    );
  }
}
