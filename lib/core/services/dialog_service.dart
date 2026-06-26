import 'package:flutter/material.dart';

import '../routes/router.dart';

typedef DialogBuilder = Widget Function(BuildContext context);

class DialogService {
  static Future<dynamic> showBasicDialog(
          {String? title, String? desc, bool showCancelBtn = true}) async =>
      await showDialog(
        context: router.configuration.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text(
            title ?? 'Title',
            // style: TextStyles.headerTextStyle,
          ),
          content: Text(desc ?? 'Subtitle'),
          actions: [
            if (showCancelBtn)
              TextButton(
                child: Text(
                  'Cancel',
                  // style: TextStyles.kButtonTextStyle.copyWith(
                  //   color: Colors.black,
                  // ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            TextButton(
              child: Text(
                'Continue',
                // style: TextStyles.kButtonTextStyle.copyWith(
                //   color: Colors.red,
                // ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );

  static Future<T> showCustomDialog<T>({required DialogBuilder builder}) async {
    return await showDialog(
      context: router.configuration.navigatorKey.currentContext!,
      builder: (context) => Center(
        child: builder(context),
      ),
    );
  }
}
