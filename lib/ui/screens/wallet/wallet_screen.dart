import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/res/icons.dart';
import '../../../core/models/wallet/transaction_summary.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/app_bars/profile_app_bar.dart';
import '../../widgets/customs/custom_action_tile.dart';
import '../../widgets/customs/svg_widget.dart';
import '../../widgets/loaders/circular_indicator.dart';
import 'bloc/wallet_bloc.dart';
import 'widgets/weekly_earnings_card.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import 'widgets/statistic_tile.dart';
import 'widgets/wallet_balance_card.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<WalletBloc>().add(FetchWalletDataRequested());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffoldWidget(
//       appBar: ProfileAppBar(
//         backgroundColor: Colors.white,
//         disableBorder: true,
//         bottom: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Wallet & Earnings",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               CircleAvatar(radius: 23, child: Icon(Icons.help_outline)),
//             ],
//           ),
//         ),
//       ),
//       child: BlocConsumer<WalletBloc, WalletState>(
//         listener: (context, state) {
//           if (state.walletStatus == WalletStatus.success) {
//             context.read<WalletBloc>().add(FetchTransactionRequested());
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 WalletBalanceCard(
//                   currency: "NGN",
//                   currentBalance: 155000.00,
//                   onWithdraw: () {},
//                   onFundWallet: () {},
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: const [
//                     Expanded(
//                       child: StatisticTile(
//                         currency: "NGN",
//                         label: "Total Earnings",
//                         value: "8,420.00",
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: StatisticTile(
//                         currency: "NGN",
//                         label: "Pending Payouts",
//                         value: "320.50",
//                         valueColor: Color(0xFF1E88E5), // Blue value for pending
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),
//                 WeeklyEarningsCard(
//                   currency: "NGN",
//                   dateRange: "Oct 14 - Oct 20",
//                   totalAmount: 840.00,
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Recent Transactions",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextButton(onPressed: () {}, child: Text("View All")),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 CustomActionTile(
//                   leadingIcon: SvgWidget(assetName: AppSvgs.packageFilled),
//                   title: 'Trip Payout - #RY9021',
//                   titleStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   subtitle: Text("Today, 2:45 PM"),
//                   trailing: Text("+\$45.20"),
//                 ),
//                 SizedBox(height: 8),
//                 CustomActionTile(
//                   leadingIcon: SvgWidget(assetName: AppSvgs.packageFilled),
//                   title: 'Trip Payout - #RY9021',
//                   titleStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   subtitle: Text("Today, 2:45 PM"),
//                   trailing: Text("+\$45.20"),
//                 ),
//                 SizedBox(height: 8),
//                 CustomActionTile(
//                   leadingIcon: SvgWidget(assetName: AppSvgs.packageFilled),
//                   title: 'Trip Payout - #RY9021',
//                   titleStyle: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   subtitle: Text("Today, 2:45 PM"),
//                   trailing: Text("+\$45.20"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletBloc>().add(FetchWalletDataRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      appBar: ProfileAppBar(
        backgroundColor: Colors.white,
        disableBorder: true,
        bottom: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Wallet & Earnings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.grey.shade100,
                child: const Icon(Icons.help_outline, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          // If wallet data fetch is successful, fetch the history
          if (state.walletStatus == WalletStatus.success &&
              state.transactionsStatus == TransactionsStatus.initial) {
            context.read<WalletBloc>().add(FetchTransactionRequested());
          }

          if (state.error != null &&
              state.walletStatus == WalletStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final wallet = state.wallet;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WalletBloc>().add(RefreshWalletRequested());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WalletBalanceCard(
                    currency: wallet?.currency ?? "NGN",
                    currentBalance: wallet?.currentBalance ?? 0.0,
                    isLoading: state.walletStatus == WalletStatus.loading,
                    onWithdraw: () => router.push(Paths.WITHDRAWFUND),
                    onFundWallet: () {},
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatisticTile(
                          currency: wallet?.currency ?? "NGN",
                          label: "Total Earnings",
                          value: wallet?.totalEarnings.toString() ?? "0.00",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticTile(
                          currency: wallet?.currency ?? "NGN",
                          label: "Pending Payouts",
                          value: wallet?.pendingPayout.toString() ?? "0.00",
                          valueColor: const Color(0xFF1E88E5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  WeeklyEarningsCard(
                    breakdown: wallet?.earningsByWeekday ?? {},
                    totalAmount: wallet?.earningsByWeekday.values.fold(
                          0.0,
                          (sum, amount) => sum! + amount,
                        ) ??
                        0.0,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => router.push(Paths.TRANSACTIONS),
                        child: const Text("View All"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTransactionList(state),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(WalletState state) {
    if (state.transactionsStatus == TransactionsStatus.loading &&
        (state.transactions == null || state.transactions!.isEmpty)) {
      return const Center(child: CircularIndicator());
    }

    if (state.transactions == null || state.transactions!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("No recent transactions found.")),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.transactions!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = state.transactions![index];
        return CustomActionTile(
          onTap: () => router.push(Paths.TRANSACTIONDETAIL, extra: item.id),
          leadingIcon: SvgWidget(
            assetName: item.type == TransactionType.packagePayout
                ? AppIcons.packagePayoutIcon
                : item.type == TransactionType.tripEarning
                ? AppIcons.tripPayoutIcon
                : AppIcons.walletPayoutIcon,
          ),
          title: '${item.displayTitle} - #${item.id}',
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          subtitle: Text(item.createdAt.toString()),
          trailing: Text(
            "${item.isCredit ? '+' : '-'}${item.currency}${item.amount}",
            style: TextStyle(
              color: item.isCredit ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
