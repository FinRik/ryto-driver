import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../../../widgets/more_info_widget.dart';
import 'bloc/payout_setup_bloc.dart';
import 'widgets/bank_detail_card.dart';
import 'widgets/payout_setting_row.dart';

class PayoutBankInfoScreen extends StatefulWidget {
  const PayoutBankInfoScreen({super.key});

  @override
  State<PayoutBankInfoScreen> createState() => _PayoutBankInfoScreenState();
}

class _PayoutBankInfoScreenState extends State<PayoutBankInfoScreen> {
  final region = sl<RegionIdentity>();
  bool get isRegionUS => region.countryCode == "US";
  @override
  void initState() {
    super.initState();
    // Use the new event to fetch the current payout
    context.read<PayoutSetupBloc>().add(FetchPayoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
        builder: (context, state) {
          // 1. Handle Full Screen Loading (Only on initial fetch)
          if (state.fetchStatus == PayoutFetchStatus.loading &&
              state.currentPayout == null) {
            return const Center(child: CircularIndicator());
          }

          // 2. Handle Critical Failure (No data and fetch failed)
          if (state.fetchStatus == PayoutFetchStatus.failure &&
              state.currentPayout == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? "An error occurred",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<PayoutSetupBloc>().add(
                      FetchPayoutRequested(),
                    ),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Access the payout directly from the unified state
          final payout = state.currentPayout;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowHeader(title: "Payout & Bank Info"),

                // 3. Conditional Bank Detail Display
                if (payout == null)
                  const _NoBankAccountsView()
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BankDetailCard(
                      bankName: payout.bankName!,
                      accountNumber: payout.accountNumber!,
                      accountName: payout.accountName!,
                      isDefault: false,
                      isVerified: true,
                      onEdit: () async {
                        final result = await router.push<bool>(
                          isRegionUS == false
                              ? Paths.PAYOUTSETUP
                              : Paths.USPAYOUTSETUP,
                          extra: true
                        );
                        if (result == true) {
                          context.read<PayoutSetupBloc>().add(
                            FetchPayoutRequested(),
                          );
                        }
                      },
                    ),
                  ),

                const SizedBox(height: 12),

                // 4. Add Bank Account Button
                Button.outline(
                  text: "Add Bank Account",
                  textColor: const Color(0xff64748B),
                  icon: Icons.add_circle_outline_sharp,
                  showPrefixIcon: true,
                  onTap: () async {
                    final result = await router.push<bool>(
                      isRegionUS == false
                          ? Paths.PAYOUTSETUP
                          : Paths.USPAYOUTSETUP,
                      extra: true
                    );
                    if (result == true) {
                      context.read<PayoutSetupBloc>().add(
                        FetchPayoutRequested(),
                      );
                    }
                  },
                  border: Border.all(color: const Color(0xff64748B)),
                ),

                const SizedBox(height: 50),

                // 5. Payout Settings Section
                const _PayoutSettingsSection(),

                const MoreInfoWidget(
                  text:
                      "Your banking information is encrypted and stored securely.",
                  icon: Icons.lock_outline,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoBankAccountsView extends StatelessWidget {
  const _NoBankAccountsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No bank accounts added yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              "Add a bank account to start receiving payouts",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PayoutSettingsSection extends StatelessWidget {
  const _PayoutSettingsSection();

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      title: "PAYOUT SETTINGS",
      padding: EdgeInsets.zero,
      titleStyle: const TextStyle(
        color: Color(0xff64748B),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
      disableBorder: true,
      bottomMargin: 12,
      child: Column(
        children: [
          PayoutSettingRow(
            icon: Icons.bolt,
            iconColor: Colors.orange,
            title: "Quick Withdrawal",
            // subtitle: "Auto-payout when balance > ₦5,000",
            subtitle: "",
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Handle toggle logic here
              },
            ),
          ),
          // const PayoutSettingRow(
          //   icon: Icons.history,
          //   iconColor: Colors.blue,
          //   title: "Withdrawal History",
          //   subtitle: "View all past transactions",
          //   trailing: Icon(Icons.chevron_right, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}

// class PayoutBankInfoScreen extends StatefulWidget {
//   const PayoutBankInfoScreen({super.key});
//
//   @override
//   State<PayoutBankInfoScreen> createState() => _PayoutBankInfoScreenState();
// }
//
// class _PayoutBankInfoScreenState extends State<PayoutBankInfoScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch payout banks when screen loads
//     context.read<PayoutSetupBloc>().add(FetchPayoutRequested());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffoldWidget(
//       child: BlocBuilder<PayoutSetupBloc, PayoutSetupState>(
//         builder: (context, state) {
//           if (state is PayoutLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state is PayoutFailure) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     state.error,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<PayoutSetupBloc>().add(
//                         FetchPayoutRequested(),
//                       );
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Success state
//           final payout = state is PayoutSuccess ? state.payout : null;
//
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const BackArrowHeader(title: "Payout & Bank Info"),
//
//                 // 1. Bank Account Cards
//                 if (payout == null)
//                   const Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 60),
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.account_balance_wallet_outlined,
//                             size: 64,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             "No bank accounts added yet",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "Add a bank account to start receiving payouts",
//                             style: TextStyle(color: Colors.grey),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: BankDetailCard(
//                       bankName: payout.bankName,
//                       accountNumber: payout.accountNumber,
//                       accountName: payout.accountName,
//                       isDefault: false,
//                       isVerified: true,
//                       // isDefault: bank.isDefault,
//                       // isVerified: bank.isVerified,
//                       onEdit: () {
//                         // TODO: Navigate to edit screen if needed
//                       },
//                     ),
//                   ),
//
//                 const SizedBox(height: 12),
//
//                 // 2. Add Bank Account Button
//                 Button.outline(
//                   text: "Add Bank Account",
//                   textColor: const Color(0xff64748B),
//                   icon: Icons.add_circle_outline_sharp,
//                   showPrefixIcon: true,
//                   onTap: () => router.push(Paths.PAYOUTSETUP),
//                   border: Border.all(color: const Color(0xff64748B)),
//                 ),
//
//                 const SizedBox(height: 50),
//
//                 // 3. Payout Settings
//                 CustomCardWidget(
//                   title: "PAYOUT SETTINGS",
//                   padding: EdgeInsets.zero,
//                   titleStyle: const TextStyle(
//                     color: Color(0xff64748B),
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.1,
//                   ),
//                   disableBorder: true,
//                   bottomMargin: 12,
//                   child: Column(
//                     children: [
//                       const PayoutSettingRow(
//                         icon: Icons.bolt,
//                         iconColor: Colors.orange,
//                         title: "Quick Withdrawal",
//                         subtitle: "Auto-payout when balance > ₦5,000",
//                         trailing: Switch(value: true, onChanged: null),
//                       ),
//                       const PayoutSettingRow(
//                         icon: Icons.history,
//                         iconColor: Colors.blue,
//                         title: "Withdrawal History",
//                         subtitle: "View all past transactions",
//                         trailing: Icon(Icons.chevron_right, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // 4. Secure Notice Footer
//                 const MoreInfoWidget(
//                   text:
//                       "Your banking information is encrypted and stored securely. Payouts are processed within 24 hours of request, excluding weekends and public holidays.",
//                   icon: Icons.lock_outline,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
