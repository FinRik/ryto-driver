part of 'wallet_bloc.dart';

enum WalletStatus {initial, loading, success, failure }
enum TransactionsStatus {initial, loading, success, failure }
enum WithdrawalStatus {initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletSummary? wallet;
  final List<TransactionItem>? transactions;
  final WithdrawalResponse? withdrawalResponse;
  final WalletStatus walletStatus;
  final TransactionsStatus transactionsStatus;
  final WithdrawalStatus withdrawalStatus;
  final String? message, error;

  const WalletState({
    this.wallet,
    this.transactions,
    this.withdrawalResponse,
    this.walletStatus = WalletStatus.initial,
    this.transactionsStatus = TransactionsStatus.initial,
    this.withdrawalStatus = WithdrawalStatus.initial,
    this.message,
    this.error,
  });

  Map<String, dynamic> toJson() {
    return {
      'wallet': wallet?.toJson(),
      'transactions': transactions?.map((e) => e.toJson()).toList(),
    };
  }

  factory WalletState.fromJson(Map<String, dynamic> json) {
    return WalletState(
      wallet: json['wallet'] != null
          ? WalletSummary.fromJson(json['wallet'])
          : null,
      transactions: (json['transactions'] as List?)
          ?.map(
            (item) => TransactionItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  WalletState copyWith({
    WalletSummary? wallet,
    WithdrawalResponse? withdrawalResponse,
    List<TransactionItem>? transactions,
    WalletStatus? walletStatus,
    TransactionsStatus? transactionsStatus,
    WithdrawalStatus? withdrawalStatus,
    String? message,
    String? error,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      withdrawalResponse: withdrawalResponse ?? this.withdrawalResponse,
      walletStatus: walletStatus ?? this.walletStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      withdrawalStatus: withdrawalStatus ?? this.withdrawalStatus,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    wallet,
    transactions,
    withdrawalResponse,
    walletStatus,
    transactionsStatus,
    withdrawalStatus,
    message,
    error,
  ];
}
