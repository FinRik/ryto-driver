import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryto_driver/core/routes/router.dart';

import '../../../../app/res/icons.dart';
import '../../../../core/models/wallet/transaction_summary.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/customs/custom_action_tile.dart';
import '../../../widgets/customs/svg_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../bloc/wallet_bloc.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
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
                onTap: () =>
                    router.push(Paths.TRANSACTIONDETAIL, extra: item.id),
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
        },
      ),
    );
  }
}
