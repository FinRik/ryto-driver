import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/currency_formatter_widget.dart';
import '../bloc/wallet_bloc.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _amountController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAndSubmit(double availableBalance) {
    final input = double.tryParse(_amountController.text) ?? 0.0;

    if (input <= 0) {
      setState(() => _localError = "Please enter a valid amount");
    } else if (input > availableBalance) {
      setState(() => _localError = "Insufficient balance");
    } else {
      setState(() => _localError = null);
      // Assuming you pass the amount in the event
      context.read<WalletBloc>().add(WithdrawalRequested(input));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.withdrawalStatus == WithdrawalStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Withdrawal Successful")),
          );
          router.push(Paths.WITHDRAWSUCCESS);
        }
      },
      builder: (context, state) {
        final availableBalance = state.wallet?.currentBalance ?? 0.0;

        return BaseScaffoldWidget(
          bgColor: Colors.white,
          appBar: AppBar(
            leading: const BackButton(color: Color(0xFF1B2559)),
            title: const Text(
              "Withdraw Funds",
              style: TextStyle(
                color: Color(0xFF1B2559),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Balance Header
                      _buildBalanceHeader(availableBalance),
                      const SizedBox(height: 32),

                      // 2. Input Amount Section
                      _buildInputSection(availableBalance),

                      if (_localError != null || state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _localError ?? state.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 3. Submit Section
              _buildSubmitSection(state, availableBalance),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceHeader(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2559),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance Available",
            style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 14),
          ),
          const SizedBox(height: 8),
          CurrencyFormatterWidget(
            amount: balance.toString(),
            textColor: Colors.white,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF05CD99), size: 16),
                SizedBox(width: 8),
                Text(
                  "Cleared & Ready to Withdraw",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(double maxBalance) {
    final region = sl<RegionIdentity>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "WITHDRAWAL AMOUNT",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8F9BBA),
              ),
            ),
            TextButton(
              onPressed: () =>
                  _amountController.text = maxBalance.toStringAsFixed(2),
              child: const Text(
                "Withdraw All",
                style: TextStyle(color: Color(0xFF0061FF)),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FE),
            borderRadius: BorderRadius.circular(16),
            border: _localError != null
                ? Border.all(color: Colors.red.shade200)
                : null,
          ),
          child: Row(
            children: [
              Text(
                region.currencySymbol,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8F9BBA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() => _localError = null),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2559),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0.00",
                    hintStyle: TextStyle(color: Color(0xFFD1D9E8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitSection(WalletState state, double balance) {
    return Column(
      children: [
        Button(
          onTap: () => _validateAndSubmit(balance),
          isBusy: state.withdrawalStatus == WithdrawalStatus.loading,
          text: "Confirm Withdrawal",
        ),
        const SizedBox(height: 16),
        const Text(
          "Funds usually arrive in your bank account within 1-3 business days.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 12),
        ),
      ],
    );
  }
}

// Widget _buildBankTile(String name, String lastFour, String id) {
//   bool isSelected = selectedBankId == id;
//   return GestureDetector(
//     onTap: () => setState(() => selectedBankId = id),
//     child: Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.white
//             : const Color(0xFFF4F7FE).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isSelected
//               ? const Color(0xFF0061FF)
//               : const Color(0xFFE0E5F2),
//           width: 1.5,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF4F7FE),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.account_balance,
//               color: Color(0xFF1B2559),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1B2559),
//                   ),
//                 ),
//                 Text(
//                   "•••• $lastFour",
//                   style: const TextStyle(color: Color(0xFF8F9BBA)),
//                 ),
//               ],
//             ),
//           ),
//           if (isSelected)
//             const Icon(Icons.check_circle, color: Color(0xFF0061FF)),
//         ],
//       ),
//     ),
//   );
// }
