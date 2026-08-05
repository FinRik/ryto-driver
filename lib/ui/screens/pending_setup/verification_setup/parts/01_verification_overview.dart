import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/res/svgs.dart';
import '../../../../../app/app_setup_locator.dart';
import '../../../../../core/enums/action_status.dart';
import '../../../../../core/enums/verification_status.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/setups/region_identity_setup.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/loaders/circular_indicator.dart';
import '../../../../widgets/more_info_widget.dart';
import '../../../../widgets/texts/header_text.dart';
import '../../../../widgets/verification_card.dart';
import '../../../home/bloc/home_bloc.dart';

class VerificationDashboard extends StatelessWidget {
  const VerificationDashboard({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final region = sl<RegionIdentity>();

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularIndicator());
        }

        final response = state.user;

        // Extract values from state (Defaulting to false if null)
        final bool isIdentityVerified = response?.identityVerified ?? false;
        final bool isLicenseVerified = response?.licenseVerified ?? false;

        // Map cleanly to your 3 exact business use cases
        final bool isCompletedView = isIdentityVerified && isLicenseVerified;
        final bool isNotSetView = !isIdentityVerified && !isLicenseVerified;
        final bool isPendingView = !isCompletedView && !isNotSetView; // One of both is false

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: isPendingView
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    // --- Dynamic Status Illustration ---
                    if (isCompletedView)
                      SvgWidget(assetName: AppSvgs.checkmark)
                    else if (isPendingView)
                      const CircleAvatar(
                        radius: 64,
                        backgroundColor: Color(0xffFBFEDE),
                        child: Icon(
                          Icons.hourglass_empty,
                          color: Color(0xff66710E),
                          size: 40,
                        ),
                      )
                    else // isNotSetView (Setup UI)
                      const CircleAvatar(
                        radius: 64,
                        backgroundColor: Color(0xffE5E7EB),
                        child: Icon(
                          Icons.assignment_ind_outlined,
                          color: Color(0xff4B5563),
                          size: 40,
                        ),
                      ),

                    const SizedBox(height: 24),

                    // --- Dynamic Header Text & Content ---
                    HeaderText(
                      label: isCompletedView
                          ? "Verification Completed"
                          : isPendingView
                          ? "Verification Pending"
                          : "Identity Verification",
                      subText: isCompletedView
                          ? "Awesome! Your documents have been successfully verified. You're fully cleared to hit the road."
                          : isPendingView
                          ? "Some documents are still missing or under review. Please update any unverified or failed items below."
                          : "To start accepting trips and earning with Ryto, we need to verify a few documents. This usually takes a few minutes.",
                      padding: EdgeInsets.zero,
                      crossAxisAlignment: isPendingView
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: isPendingView
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      centerLabel: isPendingView,
                      centerSubtitle: isPendingView,
                    ),
                    const SizedBox(height: 40),

                    // --- Verification Progress Cards ---
                    VerificationCard(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: "Identity Verification",
                      subtitle: "Government issued ID",
                      status: isNotSetView
                          ? VerificationStatusEnum.available
                          : _mapStatus(response?.identityVerified),
                      // onTap: !isIdentityVerified
                      //     ? () => pageController.animateToPage(
                      //   1,
                      //   duration: const Duration(milliseconds: 500),
                      //   curve: Curves.easeInOut,
                      // )
                      //     : null,
                    ),
                    const SizedBox(height: 16),
                    VerificationCard(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: "Driver's License",
                      subtitle: isLicenseVerified
                          ? "Class A/B valid license"
                          : "Valid government-issued license",
                      index: "2",
                      status: isNotSetView
                          ? VerificationStatusEnum.locked
                          : _mapStatus(response?.licenseVerified),
                      // onTap: isIdentityVerified && !isLicenseVerified
                      //     ? () => pageController.animateToPage(
                      //   2,
                      //   duration: const Duration(milliseconds: 500),
                      //   curve: Curves.easeInOut,
                      // )
                      //     : null,
                    ),

                    const SizedBox(height: 26),
                    MoreInfoWidget(
                      text: isPendingView
                          ? "Need help with your documents? Visit our Help Center or contact support."
                          : "Your data is encrypted and stored securely. We only use this information to verify your identity and ensure the safety of our community.",
                      textColor: isPendingView
                          ? const Color(0xffDC2626)
                          : const Color(0xff1E40AF),
                      iconColor: isPendingView
                          ? const Color(0xffDC2626)
                          : const Color(0xff1E40AF),
                    ),
                    const SizedBox(height: 26),
                  ],
                ),
              ),
            ),
            _buildBottomAction(
              context,
              isCompletedView: isCompletedView,
              isPendingView: isPendingView,
              isNotSetView: isNotSetView,
              isIdentityVerified: isIdentityVerified,
              isLicenseVerified: isLicenseVerified,
              region: region,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomAction(
      BuildContext context, {
        required bool isCompletedView,
        required bool isPendingView,
        required bool isNotSetView,
        required bool isIdentityVerified,
        required bool isLicenseVerified,
        required RegionIdentity region,
      }) {
    // 1. Determine footer helper text
    final String footerHint = isCompletedView
        ? "All documents verified"
        : isPendingView
        ? "Fixing documents takes 1-2 minutes"
        : "Usually takes 5-10 Minutes";

    // 2. Determine button action text
    final String buttonText = isCompletedView
        ? "Go to Dashboard"
        : isPendingView
        ? "Retry Verification"
        : "Start Verification";

    return BottomAppBar(
      color: const Color(0xffE7E8E9),
      height: 120,
      child: Column(
        children: [
          Text(footerHint, style: const TextStyle(color: Color(0xff9CA3AF))),
          const SizedBox(height: 11),
          Button(
            text: buttonText,
            suffixIcon: Icons.keyboard_arrow_right,
            showSuffixIcon: true,
            onTap: () {
              if (isCompletedView) {
                // If everything is done, navigate home
                context.read<HomeBloc>().add(
                  UpdateOnboardingState(
                    status: ActionStatus.completed,
                    type: OnboardingStep.verification,
                  ),
                );
                router.go(Paths.HOME);
              }
              else if (isPendingView) {
                // Determine targeted retry index dynamically based on region & failures
                int targetIndex = 1; // Default fallback index

                if (region.countryCode == "NG") {
                  // If NG and identity passed but license failed, target index 2. Otherwise target index 1.
                  targetIndex = (isIdentityVerified && !isLicenseVerified) ? 2 : 1;
                } else {
                  // US Region always routes back to index 1
                  targetIndex = 1;
                }

                pageController.animateToPage(
                  targetIndex,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              } else {
                // Setup interface (Start Verification) targets index 1
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  VerificationStatusEnum _mapStatus(bool? isVerified) {
    if (isVerified == null) return VerificationStatusEnum.available;

    return isVerified
        ? VerificationStatusEnum.completed
        : VerificationStatusEnum.available;
  }
}
