import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/api_urls.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../widgets/settings_tile.dart';
import 'bloc/security_cubit.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: SingleChildScrollView(
        child: BlocConsumer<SecurityCubit, SecurityState>(
          listener: (context, state) {
            if (state.status == BiometricStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<SecurityCubit>();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowHeader(title: 'Security & Privacy'),
                const SizedBox(height: 43),
                CustomCardWidget(
                  title: "LOGIN SECURITY".toUpperCase(),
                  disableBorder: true,
                  padding: EdgeInsets.zero,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8F9BBA),
                    letterSpacing: 1.2,
                  ),
                  child: Column(
                    children: [
                      // const Divider(height: 16),
                      // SettingsTile(
                      //   icon: Icons.fingerprint,
                      //   title: "Biometric Login",
                      //   subtitle: "FaceID or Fingerprint",
                      //   trailing: state.status == BiometricStatus.authenticating
                      //       ? const SizedBox(
                      //           width: 20,
                      //           height: 20,
                      //           child: CircularProgressIndicator(
                      //             strokeWidth: 2,
                      //           ),
                      //         )
                      //       : Switch(
                      //           value: state.isBiometricEnabled,
                      //           onChanged: cubit.toggleBiometric,
                      //           activeColor: Colors.blue,
                      //         ),
                      // ),
                      // const Divider(height: 16),
                      const Divider(height: 8),
                      SettingsTile(
                        icon: Icons.delete,
                        title: "Delete Account",
                        subtitle: "Delete your driver profile",
                        titleColor: Colors.red,
                        onTap: () => router.push(
                          Paths.WEBVIEW,
                          extra: WebviewArgs(
                            url: ApiUrls.deleteAccount,
                            title: "Delete Account",
                          ),
                        ),
                      ),
                      const Divider(height: 8),
                    ],
                  ),
                ),
                // const SizedBox(height: 23),
                // CustomCardWidget(
                //   title: "FINANCIAL SECURITY".toUpperCase(),
                //   disableBorder: true,
                //   padding: EdgeInsets.zero,
                //   titleStyle: const TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF8F9BBA),
                //     letterSpacing: 1.2,
                //   ),
                //   child: Column(
                //     children: [
                //       const Divider(height: 8),
                //       SettingsTile(
                //         icon: Icons.pin_outlined,
                //         title: "Set Security PIN",
                //         subtitle: "Required for wallet withdrawals",
                //         onTap: () => router.push(Paths.SETPIN),
                //       ),
                //       const Divider(height: 8),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
