import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../core/enums/bottom_sheet_type.dart';
import '../../../../../core/models/auth/us_kyc_preflight.dart';
import '../../../../../core/services/bottom_sheet_service.dart';
import '../../../../../core/setups/region_identity_setup.dart';
import '../../../../../utils/helpers/date_formatter_utils.dart';
import '../../../../dialogs/kyc_status_dialog.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/document_upload_field.dart';
import '../../../../widgets/inputs/auth_text_field.dart';
import '../../../../widgets/inputs/expiry_date_field.dart';
import '../../../../widgets/more_info_widget.dart';
import '../bloc/verification_setup_bloc.dart';

class LicenseVerification extends StatefulWidget {
  const LicenseVerification({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<LicenseVerification> createState() => _LicenseVerificationState();
}

class _LicenseVerificationState extends State<LicenseVerification> {
  final region = sl<RegionIdentity>();
  final _formKey = GlobalKey<FormState>();
  final _licenseNumberController = TextEditingController();
  final _expiryController = TextEditingController();

  File? _frontLicense;
  File? _backLicense;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationSetupBloc, VerificationSetupState>(
      listener: (context, state) async {
        // 1. Handle Nigeria KYC Success with the Custom Dialog
        if (state.ngKycStep == NgKycStep.success && state.licenseResponse != null) {
          final response = state.licenseResponse!;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => KycStatusDialog(
              isSuccess: response.isLicenseVerified,
              isPending: response.isLicensePending,
              isRejected: response.isLicenseRejected,
              rejectionReason: response.licenseRejectionReason,
              onContinue: () {
                // Move user back to the first page/dashboard on explicit confirmation
                widget.pageController.jumpToPage(0);
              },
            ),
          );
        }

        // 2. Handle US Preflight Success
        if (state.usKycStep == UsKycStep.preflightSuccess) {
          // open bottom sheet to continue us verification
          final result = await sl<BottomSheetService>()
              .showCustomBottomSheet<USKycPreflight, bool>(
            variant: BottomSheetType.verification,
            data: state.preflightResponse,
          );

          if (result?.data == true) {
            widget.pageController.jumpToPage(0);
          }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DocumentUploadField(
                        label: "Front of License",
                        title: "Take a photo",
                        subtitle: "or tap to upload",
                        icon: Icons.camera_alt_outlined,
                        onFilePicked: (file) {
                          print("Front picked: ${file.path}");
                          setState(() {
                            _frontLicense = file;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      DocumentUploadField(
                        label: "Back of License",
                        title: "Take a photo",
                        subtitle: "or tap to upload",
                        icon: Icons.document_scanner_outlined,
                        onFilePicked: (file) {
                          print("Back picked: ${file.path}");
                          setState(() {
                            _backLicense = file;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _licenseNumberController,
                        label: "License Number",
                        hint: "Enter license number",
                        textInputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "License number is required";
                          }
                          if (value.length < 5) {
                            return "Invalid license number";
                          }
                          return null;
                        },
                      ),
                      ExpiryDateField(
                        controller: _expiryController,
                        label: "Expiry Date",
                        isFullDate: true,
                      ),
                      const SizedBox(height: 16),
                      MoreInfoWidget(
                        icon: Icons.security,
                        text:
                            "Your data is encrypted and securely stored. We only use this information for identity verification purposes as per our privacy policy.",
                        textColor: Color(0xff1E40AF),
                        iconColor: Color(0xff1E40AF),
                        bgColor: Color(0xffEFF6FF),
                      ),
                      SizedBox(height: 143),
                    ],
                  ),
                ),
              ),
            ),

            BottomAppBar(
              color: Color(0xffE7E8E9),
              height: 120,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Usually takes 5-10 Minutes",
                    style: TextStyle(color: Color(0xff9CA3AF)),
                  ),
                  SizedBox(height: 11),
                  Button(
                    text: "Start Verification",
                    suffixIcon: Icons.keyboard_arrow_right,
                    showSuffixIcon: true,
                    isBusy: region.countryCode == "US"
                        ? state.usKycStep == UsKycStep.loading
                        : state.ngKycStep == NgKycStep.loading,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (_frontLicense == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Upload the front of your license"),
                          ),
                        );
                        return;
                      }

                      if (_backLicense == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Upload the back of your license"),
                          ),
                        );
                        return;
                      }

                      if (region.countryCode == "NG") {
                        final licenseExpiryDate =
                            DateTimeHelper.parseBackendFormat(
                              _expiryController.text.trim(),
                            );

                        if (licenseExpiryDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid date of birth format"),
                            ),
                          );
                          return;
                        }

                        context.read<VerificationSetupBloc>().add(
                          VerifyLicenseRequested(
                            licenseNumber: _licenseNumberController.text.trim(),
                            expiryDate: licenseExpiryDate,
                            front: _frontLicense!,
                            back: _backLicense!,
                          ),
                        );
                      } else {
                        context.read<VerificationSetupBloc>().add(
                          SaveUsIdentityDraft(
                            driverLicenseNumber: _licenseNumberController.text
                                .trim(),
                            licenseFront: _frontLicense!,
                            licenseBack: _backLicense!,
                          ),
                        );
                        context.read<VerificationSetupBloc>().add(
                          PreflightRequested(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
