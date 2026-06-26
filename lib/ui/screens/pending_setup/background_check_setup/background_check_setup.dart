import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/action_status.dart';
import '../../../../core/routes/router.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../home/bloc/home_bloc.dart';

class BackgroundCheckScreen extends StatefulWidget {
  const BackgroundCheckScreen({super.key});

  @override
  State<BackgroundCheckScreen> createState() => _BackgroundCheckScreenState();
}

class _BackgroundCheckScreenState extends State<BackgroundCheckScreen> {
  bool criminalConsent = false;
  bool mvrConsent = false;

  bool isBusy = false;

  void updateBusyState(bool value) {
    setState(() {
      isBusy = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      bgColor: Colors.white,
      bottomNavBar: BottomAppBar(
        height: 100,
        color: Color(0xffE7E8E9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              buttonColor: (criminalConsent && mvrConsent) ? null : Colors.grey,
              onTap: () {
                if (criminalConsent && mvrConsent) {
                  updateBusyState(true);
                  Future.delayed(Duration(seconds: 3), () {
                    updateBusyState(false);
                    context.read<HomeBloc>().add(
                      UpdateOnboardingState(
                        status: ActionStatus.completed,
                        type: OnboardingStep.background,
                      ),
                    );
                    router.pop();
                  });
                }
              },
              isBusy: isBusy,
              text: "I Agree & Continue",
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackArrowHeader(
              title: "Background Check",
              setDefaultPadding: false,
            ),
            // 1. Main Header
            const HeaderText(
              label: "Background & MVR Consent",
              subText:
                  "To ensure safety and maintain our premium standards, we require a standard check of your criminal and driving history.",
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B2559),
              ),
              subTextStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFF8F9BBA),
                height: 1.5,
              ),
            ),
            // 2. Secure Verification Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6E4FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF0061FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Secure Verification",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2559),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Your data is encrypted and handled by industry-leading providers Checkr and Sterling.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F9BBA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Consent Checkboxes
            _buildConsentTile(
              "I consent to a Criminal Background Check",
              criminalConsent,
              (val) => setState(() => criminalConsent = val!),
            ),
            const SizedBox(height: 12),
            _buildConsentTile(
              "I consent to a Motor Vehicle Record (MVR) check",
              mvrConsent,
              (val) => setState(() => mvrConsent = val!),
            ),
            const SizedBox(height: 32),

            // 4. Compliance Imagery
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/transparency_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "TRANSPARENCY & COMPLIANCE\nARCHITECTURE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 5. Terms Disclaimer
            const Center(
              child: Text(
                "By tapping agree, you confirm you have read the\nBackground Check Disclosure and Ryto's Terms of Service",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8F9BBA),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentTile(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1B2559)),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: const Color(0xFF0061FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
