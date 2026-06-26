import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../utils/helpers/call_service_util.dart';
import '../../../../widgets/buttons/back_arrow_header.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/inputs/otp_input_field.dart';
import '../../../../widgets/layouts/base_scaffold_widget.dart';
import '../../bloc/auth_bloc.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key, required this.args});

  final VerifyOtpArgs args;

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  static const int _initialSeconds = 59;
  late int _secondsRemaining;
  Timer? _timer;
  String _otp = "";

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _initialSeconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    setState(() {
      _secondsRemaining = _initialSeconds;
    });
    _startCountdown();

    context.read<AuthBloc>().add(ResendOtpRequested());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    // return "$minutes:$seconds";
    return seconds;
  }

  Future<void> _showError(
    BuildContext context, {
    required String message,
    String title = 'Error',
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (widget.args.isLogin) {
              router.go(Paths.HOME);
            } else {
              router.go(Paths.ACCOUNTSETUP);
            }
          } else if (state is AuthFailure) {
            _showError(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackArrowHeader(
                    title: "Verify Your Phone number",
                    subText:
                        "A code was sent to ${CallServiceUtil.maskPhoneNumber(widget.args.phone)}",
                    setDefaultPadding: true,
                  ),

                  OtpInputField(
                    fieldLength: 4,
                    onChanged: (pin, isValid) {
                      _otp = pin;
                    },
                  ),

                  const SizedBox(height: 16),

                  _secondsRemaining > 0
                      ? Text.rich(
                          TextSpan(
                            text: "Resend code ",
                            children: [
                              TextSpan(
                                text: "${_formattedTime}s",
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            color: Color(0xff696E7E),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : GestureDetector(
                          onTap: _resendCode,
                          child: const Text(
                            "Resend Code",
                            style: TextStyle(
                              color: Color(0xff696E7E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ],
              ),

              Button(
                text: "Continue",
                isBusy: state is AuthLoading,
                onTap: () {
                  if (widget.args.isLogin) {
                    context.read<AuthBloc>().add(
                      VerifyLoginRequested(
                        phone: widget.args.phone,
                        code: _otp,
                      ),
                    );
                  } else {
                    context.read<AuthBloc>().add(VerifyOtpRequested(_otp));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
