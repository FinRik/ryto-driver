import 'package:flutter/material.dart';

import '../../../app/res/images.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/texts/header_text.dart';
import '../../widgets/texts/terms_text.dart';
import 'widgets/dot_indication.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(AppImages.onboardOne),
                  HeaderText(
                    label: "Earn from trips you’re already planning.",
                    subText: "Turn empty seats or trunk space into extra income on your next intercity trip.",
                    labelStyle: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600
                    ),
                    subTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Button(
                    text: 'Create Driver Account',
                    onTap: () {
                      router.push(Paths.REGISTERACCOUNT);
                    },
                    showSuffixIcon: true,
                    suffixIcon: Icons.keyboard_arrow_right_outlined,
                  ),
                  SizedBox(height: 8,),
                  Button.outline(text: 'Login', onTap: () {
                    router.push(Paths.LOGIN);
                  },),
                  SizedBox(height: 32,),
                  TermsText(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
