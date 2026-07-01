import 'package:flutter/material.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/currency_formatter_widget.dart';

class WalletBalanceCard extends StatelessWidget {
  final double currentBalance;
  final bool isLoading;
  final VoidCallback onWithdraw;
  final VoidCallback onFundWallet;

  const WalletBalanceCard({
    super.key,
    required this.currentBalance,
    this.isLoading = false,
    required this.onWithdraw,
    required this.onFundWallet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1565C0)], // Subtle gradient
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Available Balance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              if (isLoading)
                const SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: CurrencyFormatterWidget(
                amount: "$currentBalance",
                textColor: Colors.white,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _WalletActionButton(
                  label: "Withdraw",
                  icon: Icons.account_balance_wallet_outlined,
                  onPressed: isLoading ? () {} : onWithdraw,
                  isPrimary: true,
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: _WalletActionButton(
              //     label: "Fund",
              //     icon: Icons.add_circle_outline,
              //     onPressed: onFundWallet,
              //     isPrimary: false,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

// class _WalletActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onPressed;
//   final bool isPrimary;
//
//   const _WalletActionButton({
//     required this.label,
//     required this.icon,
//     required this.onPressed,
//     required this.isPrimary,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isPrimary ? Colors.white : Colors.transparent,
//         foregroundColor: isPrimary ? const Color(0xFF1E88E5) : Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//           side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.white70),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 14),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 18),
//           const SizedBox(width: 8),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

class _WalletActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _WalletActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        foregroundColor: isPrimary ? const Color(0xFF1E88E5) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Colors.white70),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: isPrimary ? const Color(0xFF1E88E5) : Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isPrimary ? const Color(0xFF1E88E5) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
