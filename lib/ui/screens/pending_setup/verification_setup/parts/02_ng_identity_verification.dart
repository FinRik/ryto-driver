import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/res/icons.dart';
import '../../../../dialogs/kyc_status_dialog.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/customs/face_verification_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/document_upload_field.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import '../../../../widgets/more_info_widget.dart';
import '../../../../widgets/texts/header_text.dart';
import '../bloc/verification_setup_bloc.dart';

class NGIdentityVerification extends StatefulWidget {
  const NGIdentityVerification({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<NGIdentityVerification> createState() => _NGIdentityVerificationState();
}

class _NGIdentityVerificationState extends State<NGIdentityVerification> {
  final _formKey = GlobalKey<FormState>();
  final _ninController = TextEditingController();

  File? _selfieFile;
  File? _ninDocument;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationSetupBloc, VerificationSetupState>(
      listener: (context, state) async {
        if (state.ngKycStep == NgKycStep.success &&
            state.identityResponse != null) {
          final response = state.identityResponse!;

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => KycStatusDialog(
              isSuccess: response.isIdentityVerified,
              isPending: response.isIdentityPending,
              isRejected: response.isIdentityRejected,
              rejectionReason: response.identityRejectionReason,
              onContinue: () {
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
          );
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeaderText(
                        label: "Selfie Capture",
                        subText: "Position your face within the circle",
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      SizedBox(height: 16),
                      FaceVerificationWidget(
                        isImagePicker: false,
                        onChange: (file, status) {
                          if (file != null) {
                            setState(() {
                              _selfieFile = file;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: BoxBorder.all(color: Color(0xffF1F5F9)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgWidget(assetName: AppIcons.light),
                                SizedBox(width: 8),
                                Text("Good Lightning"),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 26,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: BoxBorder.all(color: Color(0xffF1F5F9)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgWidget(assetName: AppIcons.eye),
                                SizedBox(width: 8),
                                Text("No glasses"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 36),
                      Divider(color: Color(0xffE2E8F0)),
                      HeaderText(
                        label: "National Identification Number (NIN)",
                        subText:
                            "Enter your 11-digit NIN as it appears on your ID",
                        labelStyle: TextStyle(fontSize: 16),
                        subTextStyle: TextStyle(fontSize: 14),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(height: 16),
                      GeneralTextField(
                        controller: _ninController,
                        prefixIcon: null,
                        hint: "Enter 11 digit NIN",
                        textInputType: TextInputType.phone,
                        inputFormatters: [LengthLimitingTextInputFormatter(11)],
                        margin: EdgeInsets.zero,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "NIN is required";
                          }

                          if (value.length != 11) {
                            return "NIN must be 11 digits";
                          }

                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return "NIN must contain only numbers";
                          }

                          return null;
                        },
                        label: null,
                        // prefixIcon: null,
                      ),
                      SizedBox(height: 4),
                      DocumentUploadField(
                        title: "Upload NIN Slip or Plastic ID",
                        subtitle: "JPG, PNG or PDF (Max 5MB)",
                        icon: Icons.cloud_upload_outlined,
                        onFilePicked: (file) {
                          print("NIN picked: ${file.path}");
                          setState(() {
                            _ninDocument = file;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      MoreInfoWidget(
                        text:
                            "Your data is encrypted and handled securely in accordance with NDPR regulations. Verification usually takes less than 5 minutes.",
                        textColor: Color(0xff1E40AF),
                        iconColor: Color(0xff1E40AF),
                        bgColor: Color(0xffEFF6FF),
                      ),
                      SizedBox(height: 103),
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
                    isBusy: state.ngKycStep == NgKycStep.loading,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;

                      if (_selfieFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please capture a selfie"),
                          ),
                        );
                        return;
                      }

                      if (_ninDocument == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Upload your NIN document"),
                          ),
                        );
                        return;
                      }

                      context.read<VerificationSetupBloc>().add(
                        VerifyNinRequested(
                          identityType: "NIN",
                          nin: _ninController.text.trim(),
                          selfie: _selfieFile!,
                          document: _ninDocument!,
                        ),
                      );
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
