import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../widgets/buttons/back_arrow_header.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/inputs/country_phone_input_field.dart';
import '../../../../widgets/texts/terms_text.dart';
import '../../bloc/auth_bloc.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _phone;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              router.push(Paths.VERIFYPHONENUMBER, extra: _phone);
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 11,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        BackArrowHeader(
                          title: "Create Account",
                          subText:
                              "Join the Ryto community of professional drivers and start earning today.",
                        ),

                        const SizedBox(height: 81),

                        CountryPhoneInputField(
                          onChanged: (phone) {
                            _phone = phone;
                          },
                        ),

                        const SizedBox(height: 48),

                        Button(
                          isBusy: state is AuthLoading,
                          text: 'Continue',
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                RegisterRequested(_phone!),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            children: const [
                              TextSpan(
                                text: "Log in",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22.9),
                        const TermsText(),
                        const SizedBox(height: 22.9),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
