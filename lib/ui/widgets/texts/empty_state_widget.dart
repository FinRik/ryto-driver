import 'package:flutter/material.dart';


class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title?? "Nothing to show at the moment",
        style: TextStyle(
          fontSize: 14,
          // color: appTheme.neutral1400,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
