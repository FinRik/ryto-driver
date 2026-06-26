import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/inputs/country_phone_input_field.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../app/res/images.dart';
import '../../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _phone;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            router.go(
              Paths.VERIFYPHONENUMBER,
              extra: VerifyOtpArgs(phone: _phone!, isLogin: true),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Image.asset(
                AppImages.onboardFour,
                width: double.maxFinite,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 53),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          CountryPhoneInputField(
                            onChanged: (phone) {
                              _phone = phone;
                            },
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffFCFFE9),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              "Your number is used for trip updates and driver communication.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Register Button with Loading State
                          Button(
                            isBusy: state is AuthLoading,
                            text: 'Login',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginRequested(_phone!),
                                );
                              }
                            },
                          ),

                          SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black54, // Style for the plain text
                                fontSize: 16,
                              ),
                              children: [
                                const TextSpan(text: "Don’t have an account? "),
                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    color: Colors.blue, // Style for the clickable text
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      router.push(Paths.REGISTERACCOUNT);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
