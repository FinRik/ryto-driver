import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../widgets/settings_tile.dart';
import 'bloc/security_cubit.dart';

// class SecurityPrivacyScreen extends StatelessWidget {
//   const SecurityPrivacyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffoldWidget(
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             BackArrowHeader(title: 'Security & Privacy'),
//             SizedBox(height: 43),
//             CustomCardWidget(
//               title: "LOGIN SECURITY".toUpperCase(),
//               disableBorder: true,
//               padding: EdgeInsets.zero,
//               titleStyle: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF8F9BBA), // Muted blue-gray
//                 letterSpacing: 1.2,
//               ),
//               child: Column(
//                 children: [
//                   // const Divider(height: 16),
//                   // SettingsTile(
//                   //   icon: Icons.lock_outline,
//                   //   title: "Change Password",
//                   //   onTap: () => router.push(Paths.CHANGEPASSWORD),
//                   // ),
//                   const Divider(height: 16),
//                   SettingsTile(
//                     icon: Icons.fingerprint,
//                     title: "Biometric Login",
//                     subtitle: "FaceID or Fingerprint",
//                     trailing: Switch(
//                       value: true,
//                       onChanged: (val) {},
//                       activeColor: Colors.blue,
//                     ),
//                   ),
//                   const Divider(height: 16),
//                 ],
//               ),
//             ),
//             SizedBox(height: 23),
//             CustomCardWidget(
//               title: "FINANCIAL SECURITY".toUpperCase(),
//               disableBorder: true,
//               padding: EdgeInsets.zero,
//               titleStyle: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF8F9BBA), // Muted blue-gray
//                 letterSpacing: 1.2,
//               ),
//               child: Column(
//                 children: [
//                   const Divider(height: 8),
//                   SettingsTile(
//                     icon: Icons.pin_outlined,
//                     title: "Set Security PIN",
//                     subtitle: "Required for wallet withdrawals",
//                     onTap: () => router.push(Paths.SETPIN),
//                   ),
//                   const Divider(height: 16),
//                 ],
//               ),
//             ),
//
//             const Divider(height: 16),
//             // SettingsTile(
//             //   icon: Icons.delete_outline,
//             //   title: "Delete Account",
//             //   titleColor: Colors.red,
//             //   onTap: () {},
//             //   trailing: const SizedBox.shrink(), // No chevron for delete
//             // ),
//             // const Divider(height: 16),
//             // const Padding(
//             //   padding: EdgeInsets.all(24.0),
//             //   child: Text(
//             //     "Deleting your account is permanent and cannot be undone. All your data and earnings history will be removed.",
//             //     textAlign: TextAlign.center,
//             //     style: TextStyle(
//             //       color: Color(0xFF637381),
//             //       fontSize: 13,
//             //       height: 1.5,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: SingleChildScrollView(
        child: BlocConsumer<SecurityCubit, SecurityState>(
          listener: (context, state) {
            if (state.status == BiometricStatus.failure && state.errorMessage != null) {
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
                      const Divider(height: 16),
                      SettingsTile(
                        icon: Icons.fingerprint,
                        title: "Biometric Login",
                        subtitle: "FaceID or Fingerprint",
                        trailing: state.status == BiometricStatus.authenticating
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Switch(
                          value: state.isBiometricEnabled,
                          onChanged: cubit.toggleBiometric,
                          activeColor: Colors.blue,
                        ),
                      ),
                      const Divider(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                CustomCardWidget(
                  title: "FINANCIAL SECURITY".toUpperCase(),
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
                      const Divider(height: 8),
                      SettingsTile(
                        icon: Icons.pin_outlined,
                        title: "Set Security PIN",
                        subtitle: "Required for wallet withdrawals",
                        onTap: () => router.push(Paths.SETPIN),
                      ),
                      const Divider(height: 16),
                    ],
                  ),
                ),
                const Divider(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}