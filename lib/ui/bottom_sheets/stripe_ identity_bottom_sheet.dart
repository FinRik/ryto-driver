import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_identity_plugin/stripe_identity_plugin.dart';
import 'package:stripe_identity_plugin/utils/enum.dart';
import 'package:stripe_identity_plugin/utils/identity_style.dart';

import '../../app/res/icons.dart';
import '../../app/res/svgs.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../screens/pending_setup/verification_setup/bloc/verification_setup_bloc.dart';
import '../widgets/buttons/button.dart';
import '../widgets/customs/svg_widget.dart';
import '../widgets/layouts/base_bottom_sheet.dart';
import '../widgets/texts/header_text.dart';

class StripeIdentityBottomSheet extends StatefulWidget {
  const StripeIdentityBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  State<StripeIdentityBottomSheet> createState() =>
      _StripeIdentityBottomSheetState();
}

class _StripeIdentityBottomSheetState extends State<StripeIdentityBottomSheet> {
  final _identityPlugin = StripeIdentityPlugin();
  final _pageController = PageController();

  bool isLoading = false;
  String? verificationId;
  String? ephemeralKey;

  @override
  void initState() {
    super.initState();
    _parseInitialData();
  }

  void _parseInitialData() {
    if (_hasValidCredentials) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(1);
        }
      });
    }
  }

  bool get _hasValidCredentials =>
      verificationId != null &&
      verificationId!.isNotEmpty &&
      ephemeralKey != null &&
      ephemeralKey!.isNotEmpty;

  void _navigateToNextPage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationSetupBloc, VerificationSetupState>(
      listener: (ctx, state) {
        if (state.usKycStep == UsKycStep.success &&
            state.verificationResponse != null) {
          setState(() {
            verificationId = state.verificationResponse?.verificationSessionId;
            ephemeralKey = state.verificationResponse?.ephemeralKeySecret;
          });

            // Smoothly slide to the Stripe action page now that we have the tokens
          if (_hasValidCredentials) {
            _navigateToNextPage();
          }
        }
      },
      builder: (ctx, state) => BaseBottomSheet(
        multiplier: .54,
        hasScrollableChild: true,
        builder: (context, size) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // PAGE 0: Preflight Completion / Setup Page
              _buildPreflightPage(context, state == UsKycStep.loading),

              // PAGE 1: Stripe Verification Trigger Page
              _buildStripeVerificationPage(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPreflightPage(BuildContext context, bool isLoading) {
    // If we don't have keys and we don't have preflight data, show error state
    if (widget.request.data == null && !_hasValidCredentials) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderText(
              label: "Verification Failed",
              subText: "Failed to verify configuration data.",
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              centerSubtitle: true,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgWidget(
            assetName: AppSvgs.checkmark,
          ),
          HeaderText(
            label: "Ready for Verification",
            subText:
                "Your details have been pre-verified successfully. Proceed to identity matching.",
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            centerSubtitle: true,
          ),
          const SizedBox(height: 24),
          Button(
            text: "Complete Verification",
            isBusy: isLoading,
            onTap: () => context.read<VerificationSetupBloc>().add(
              VerifyUsKycRequested(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStripeVerificationPage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgWidget(
              assetName: AppIcons.face,
            ),
            HeaderText(
              label: "Identity Check",
              subText:
                  "We'll use Stripe to securely process your identity documents.",
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              centerSubtitle: true,
            ),
            const SizedBox(height: 24),
            Button(
              onTap: () => _handleStripeVerification(context),
              text: ("Start verification"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStripeVerification(BuildContext context) async {
    if (!_hasValidCredentials) return;

    setState(() => isLoading = true);

    final response = await _identityPlugin.startVerification(
      id: verificationId!,
      key: ephemeralKey!,
      brandLogoUrl: "https://img.icons8.com/?size=128&id=77153&format=png",
      style: const IdentityStyle(
        buttonBackgroundColor: Colors.blue,
        buttonTextColor: Colors.white,
        navigationBarTitle: "Stripe Identity Example",
      ),
    );

    setState(() => isLoading = false);

    if (!context.mounted) return;

    switch (response.$1) {
      case VerificationResult.completed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.$2 ?? "Verification completed")),
        );
        widget.completer(
          SheetResponse(confirmed: true),
        );
        break;
      case VerificationResult.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.$2 ?? "Verification failed")),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.$2 ?? "Verification couldn't be completed"),
          ),
        );
    }
  }
}
