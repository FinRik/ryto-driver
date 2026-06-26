import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w400
          ),
          children: [
            const TextSpan(
              text: "By continuing, you agree to Ryto's ",
            ),
            TextSpan(
              text: "Terms of Service",
              style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Terms of Service tapped");
                  // Navigate to Terms page
                },
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("Privacy Policy tapped");
                  // Navigate to Privacy page
                },
            ),
            const TextSpan(text: "."),
          ],
        ),
      ),
    );
  }
}