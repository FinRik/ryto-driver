import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/country/us_state.dart';
import '../../../../../utils/helpers/date_formatter_utils.dart';
import '../../../../bottom_sheets/us_state_bottom_sheet.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/inputs/auth_text_field.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import '../../../../widgets/more_info_widget.dart';
import '../../../../widgets/texts/header_text.dart';
import '../bloc/verification_setup_bloc.dart';

class USIdentityVerification extends StatefulWidget {
  const USIdentityVerification({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<USIdentityVerification> createState() => _USIdentityVerificationState();
}

class _USIdentityVerificationState extends State<USIdentityVerification> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the new request body fields
  final _ssnController = TextEditingController();
  final _dobController = TextEditingController();
  final _licenseStateController = TextEditingController();
  final _zipcodeController = TextEditingController();

  Future<void> _loadAndShowPicker() async {
    if (!mounted) return;

    final selectedState = await showModalBottomSheet<USState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => UsStateBottomSheet(),
    );

    if (selectedState != null) {
      setState(() {
        _licenseStateController.text = selectedState.shortcode;
      });
    }
  }

  @override
  void dispose() {
    _ssnController.dispose();
    _dobController.dispose();
    _licenseStateController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationSetupBloc, VerificationSetupState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(
                        label: "Personal Details",
                        subText:
                            "Provide your information as it appears on your ID",
                        labelStyle: TextStyle(fontSize: 16),
                        subTextStyle: TextStyle(fontSize: 14),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),

                      // SSN Field
                      GeneralTextField(
                        controller: _ssnController,
                        label: "Social Security Number (SSN)",
                        hint: "123456789",
                        prefixIcon: null,
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(9)],
                        validator: (v) =>
                            (v == null || v.isEmpty) ? "SSN is required" : null,
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _dobController,
                        label: "Date of Birth (YYYY-MM-DD)",
                        hint: "Select a Date",
                        readOnly: true,
                        textInputType: TextInputType.datetime,
                        bottomMargin: 0,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "Date of birth is required"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // State and Zipcode Row
                      Row(
                        children: [
                          Expanded(
                            child: GeneralTextField(
                              controller: _licenseStateController,
                              hint: "State (e.g. CA)",
                              label: "State",
                              prefixIcon: null,
                              readOnly: true,
                              suffixIcon: IconButton(
                                onPressed: _loadAndShowPicker,
                                icon: Icon(Icons.keyboard_arrow_down),
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? "Required" : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GeneralTextField(
                              controller: _zipcodeController,
                              hint: "Enter Zipcode",
                              label: "Zipcode",
                              prefixIcon: null,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5),
                              ],
                              textInputType: TextInputType.number,
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? "Required" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const MoreInfoWidget(
                        text:
                            "Your data is encrypted and handled securely in accordance with US privacy laws.",
                        textColor: Color(0xff1E40AF),
                        iconColor: Color(0xff1E40AF),
                        bgColor: Color(0xffEFF6FF),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomAction(context),
          ],
        );
      },
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFC),
        border: Border(top: BorderSide(color: Color(0xffE2E8F0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Usually takes 5-10 Minutes",
            style: TextStyle(color: Color(0xff9CA3AF)),
          ),
          const SizedBox(height: 11),
          Button(
            text: "Continue to Documents",
            suffixIcon: Icons.keyboard_arrow_right,
            showSuffixIcon: true,
            onTap: () {
              if (!_formKey.currentState!.validate()) return;

              final dob = DateTimeHelper.parseBackendFormat(
                _dobController.text.trim(),
              );

              if (dob == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid date of birth format")),
                );
                return;
              }

              context.read<VerificationSetupBloc>().add(
                SaveUsIdentityDraft(
                  ssn: _ssnController.text.trim(),
                  dob: dob,
                  driverLicenseState: _licenseStateController.text.trim(),
                  zipcode: _zipcodeController.text.trim(),
                ),
              );

              widget.pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}