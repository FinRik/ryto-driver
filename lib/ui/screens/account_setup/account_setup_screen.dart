import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/models/user/profile_request.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../core/repos/regional_manager_repo.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../../utils/helpers/date_formatter_utils.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/buttons/back_arrow_header.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/customs/face_verification_widget.dart';
import '../../widgets/inputs/auth_text_field.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/texts/header_text.dart';
import '../../widgets/texts/terms_text.dart';
import 'widgets/region_notification.dart';
import 'widgets/states_city_form.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _region = sl<RegionIdentity>();
  bool _isRegionInitialized = false;

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await _initRegion(),
    );
  }

  Future<void> _initRegion() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 800)),
        context.read<RegionalManagerRepo>().initializeRegion(),
      ]);

      if (mounted) {
        setState(() {
          _isRegionInitialized = true;
          _nationalityController.text = _region.country;
        });
      }
    } catch (e) {
      debugPrint("Region initialization error: $e");
      if (mounted) {
        setState(() {
          _isRegionInitialized = true;
          _nationalityController.text = "Nigeria";
        });
      }
    }
  }

  // Show notification banner when region is detected
  Widget _buildRegionNotification() {
    if (!_isRegionInitialized) {
      return const SizedBox.shrink();
    }

    return RegionNotification(
      onPressed: _showRegionSelector,
      country: _region.country,
    );
  }

  Future<void> _showRegionSelector() async {
    final selectedCode = await context.read<RegionalManagerRepo>().setRegion();

    if (selectedCode != null && mounted) {
      final updatedRegion = sl<RegionIdentity>();

      setState(() {
        _nationalityController.text = updatedRegion.country;

        _stateController.clear();
        _cityController.clear();
        _addressController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Region updated to ${updatedRegion.country}"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.uploadStatus == UploadStatus.success) {
            _uploadedImageUrl = state.uploadedImagUrl;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile photo uploaded successfully"),
              ),
            );
          }

          // 2. Handle Profile Data Update Success
          if (state.status == ProfileStatus.success &&
              state.message == "Update Successful") {
            router.go(Paths.VERIFICATIONSETUP, extra: false);
          }

          // 3. Handle Errors (General or Upload)
          if (state.status == ProfileStatus.failure ||
              state.uploadStatus == UploadStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? "An error occurred")),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackArrowHeader(
                        title: "Complete Profile",
                        setDefaultPadding: false,
                      ),
                      const SizedBox(height: 76),

                      // Profile Photo Section
                      Column(
                        children: [
                          FaceVerificationWidget(
                            isImagePicker: true,
                            isBusy:
                                state.uploadStatus == UploadStatus.uploading,
                            onChange: (file, status) {
                              if (file != null) {
                                context.read<ProfileBloc>().add(
                                  UpdateProfilePicRequested(file),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          HeaderText(
                            label: 'Upload Profile Photo',
                            subText: "Clear face photo recommended",
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0066FF),
                            ),
                            subTextStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 19),
                      VerifiedDataNotification(
                        title: "Provide verified information",
                        message: "Enter your details exactly as it appears on your government-issued ID.",
                      ),
                      const SizedBox(height: 8),

                      // Form Fields
                      AuthTextField(
                        controller: _firstnameController,
                        textInputType: TextInputType.text,
                        label: "Firstname",
                        hint: "Enter your Firstname",
                        validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? "Firstname is required"
                            : null,
                      ),
                      AuthTextField(
                        controller: _lastnameController,
                        textInputType: TextInputType.text,
                        label: "Surname",
                        hint: "Enter your Surname",
                        validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? "Surname is required"
                            : null,
                      ),
                      AuthTextField(
                        controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        label: "Email Address",
                        hint: "jondoe@email.com",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email address is required";
                          }

                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }

                          return null;
                        },
                      ),

                      AuthTextField(
                        controller: _dobController,
                        label: "Date of Birth",
                        hint: "Select a Date",
                        readOnly: true,
                        textInputType: TextInputType.datetime,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? "Date of birth is required"
                            : null,
                      ),
                      _buildRegionNotification(),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _nationalityController,
                        textInputType: TextInputType.text,
                        label: "Country",
                        hint: "Your Country",
                        readOnly: true,
                        suffixIcon: IconButton(
                          onPressed: _showRegionSelector,
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        validator: (value) => (value?.trim().isEmpty ?? true)
                            ? "Country is required"
                            : null,
                      ),

                      // State & City Form (Now receives controllers)
                      if (_nationalityController.text.isNotEmpty)
                        AnimatedOpacity(
                          opacity: _nationalityController.text.isNotEmpty
                              ? 1.0
                              : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              StateCityForm(
                                stateController: _stateController,
                                cityController: _cityController,
                                region: _nationalityController
                                    .text, // Pass current country
                              ),
                              const SizedBox(height: 8),

                              // Home Address
                              AuthTextField(
                                controller: _addressController,
                                textInputType: TextInputType.streetAddress,
                                label: "Home Address",
                                hint: "Enter Street Address",
                                validator: (value) =>
                                    (value?.trim().isEmpty ?? true)
                                    ? "Address is required"
                                    : null,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 47),

                  // Continue Button
                  Button(
                    text: "Continue",
                    suffixIcon: Icons.keyboard_arrow_right,
                    showSuffixIcon: true,
                    isBusy: state.status == ProfileStatus.loading,
                    onTap: _onContinuePressed,
                  ),

                  const SizedBox(height: 11),
                  TermsText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 6. Updated the validation logic to check state.user
  void _onContinuePressed() {
    if (!_formKey.currentState!.validate()) return;

    if (_uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a profile photo"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final firstname = _firstnameController.text.trim();
    final lastname = _lastnameController.text.trim();
    final dob = DateTimeHelper.parseBackendFormat(
      _dobController.text.trim(),
    );

    if (dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid date of birth format")),
      );
      return;
    }

    final request = ProfileRequest(
      firstName: firstname,
      lastName: lastname,
      email: _emailController.text.trim(),
      dateOfBirth: dob,
      homeAddress: _addressController.text.trim(),
      country: _nationalityController.text,
      state: _stateController.text.trim(),
      city: _cityController.text.trim(),
      profilePicture: _uploadedImageUrl!,
    );
    context.read<ProfileBloc>().add(UpdateProfileRequested(request));
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
