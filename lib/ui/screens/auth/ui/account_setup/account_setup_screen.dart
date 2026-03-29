import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/auth/driver_profile_request.dart';
import '../../../../widgets/customs/face_verification_widget.dart';
import '../../../../widgets/buttons/back_arrow_header.dart';
import '../../../../widgets/inputs/auth_text_field.dart';
import '../../../../widgets/texts/header_text.dart';
import '../../../../widgets/texts/terms_text.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../bloc/auth_bloc.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              router.push(Paths.VERIFICATIONOVERVIEW);
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BackArrowHeader(
                            title: "Complete Profile",
                            setDefaultPadding: false,
                          ),
                          SizedBox(height: 76),
                          Column(
                            children: [
                              FaceVerificationWidget(
                                isImagePicker: true,
                                onChange: (file, status) {
                                  if (file != null) {
                                    context.read<AuthBloc>().add(
                                      UpdateProfilePicRequested(file),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 16),
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
                          SizedBox(height: 19),
                          AuthTextField(
                            controller: _fullNameController,
                            label: "Full name",
                            textInputType: TextInputType.text,
                            hint: "Enter your Full Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Full name is required";
                              }
                              return null;
                            },
                          ),
                          AuthTextField(
                            controller: _dobController,
                            label: "Date of Birth",
                            textInputType: TextInputType.datetime,
                            hint: "Select a Date",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Date of birth is required";
                              }
                              return null;
                            },
                          ),
                          AuthTextField(
                            controller: _addressController,
                            label: "Home Address",
                            textInputType: TextInputType.text,
                            hint: "Enter Street Address",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Address is required";
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AuthTextField(
                                  controller: _stateController,
                                  label: "State",
                                  hint: "Select State",
                                  textInputType: TextInputType.text,
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "State required";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 21),
                              Expanded(
                                child: AuthTextField(
                                  controller: _cityController,
                                  label: "City",
                                  hint: "Select City",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "City required";
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.text,
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 47),
                      Button(
                        text: "Continue",
                        suffixIcon: Icons.keyboard_arrow_right,
                        showSuffixIcon: true,
                        isBusy: state is AuthLoading,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;

                          final names = _fullNameController.text.trim().split(
                            " ",
                          );

                          final request = DriverProfileRequest(
                            firstName: names.first,
                            lastName: names.length > 1 ? names.last : "",
                            email: "",
                            dateOfBirth: DateTime.parse(
                              _dobController.text.trim(),
                            ),
                            homeAddress: _addressController.text,
                            country: "Nigeria",
                            state: _stateController.text,
                            city: _cityController.text,
                            profilePicture: "",
                            status: "ACTIVE",
                          );

                          context.read<AuthBloc>().add(
                            UpdateProfileRequested(request),
                          );
                        },
                      ),
                      SizedBox(height: 11),
                      TermsText(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
