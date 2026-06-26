import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../core/models/wallet/transaction_summary.dart';
import '../../../../core/models/wallet/wallet_summary.dart';
import '../../../../core/models/wallet/withdrawal_response.dart';
import '../../../../core/repos/wallet_repo.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends HydratedBloc<WalletEvent, WalletState> {
  final WalletRepo repo;

  WalletBloc(this.repo) : super(const WalletState()) {
    on<FetchWalletDataRequested>(_onFetchWalletData);
    on<FetchTransactionRequested>(_onFetchTransaction);
    on<WithdrawalRequested>(_onRequestWithdrawal);
    on<RefreshWalletRequested>((event, emit) async {
      add(FetchWalletDataRequested());
      add(FetchTransactionRequested());
    });
  }

  @override
  WalletState? fromJson(Map<String, dynamic> json) =>
      WalletState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WalletState state) => state.toJson();

  Future<void> _onFetchWalletData(
    WalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    final showLoading = state.wallet == null;

    emit(
      state.copyWith(
        walletStatus: showLoading ? WalletStatus.loading : state.walletStatus,
        error: null,
      ),
    );

    try {
      final wallet = await repo.fetchUserWallet();
      if (wallet != null) {
        emit(
          state.copyWith(
            wallet: wallet,
            walletStatus: WalletStatus.success,
            message: "Successful",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          walletStatus: WalletStatus.failure,
          error: "Failed to load wallet: $e",
        ),
      );
    }
  }

  Future<void> _onFetchTransaction(
    WalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    final showLoading =
        state.transactions == null || state.transactions!.isEmpty;

    emit(
      state.copyWith(
        transactionsStatus: showLoading
            ? TransactionsStatus.loading
            : state.transactionsStatus,
      ),
    );

    try {
      final transactions = await repo.fetchTransactions();
      emit(
        state.copyWith(
          transactions: transactions,
          transactionsStatus: TransactionsStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          transactionsStatus: TransactionsStatus.failure,
          error: "Failed to load transactions: $e",
        ),
      );
    }
  }

  Future<void> _onRequestWithdrawal(
    WithdrawalRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(withdrawalStatus: WithdrawalStatus.loading));

    try {
      final result = await repo.requestWithdrawal(event.amount);

      if (result != null) {
        emit(
          state.copyWith(
            withdrawalResponse: result,
            withdrawalStatus: WithdrawalStatus.success,
            message: "Withdrawal request submitted successfully!",
          ),
        );
      }
      add(FetchWalletDataRequested());
    } catch (e) {
      emit(
        state.copyWith(
          withdrawalStatus: WithdrawalStatus.failure,
          error: "Withdrawal failed: $e",
        ),
      );
    }
  }
}
