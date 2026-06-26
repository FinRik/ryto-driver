import '../../app/app_setup_locator.dart';
import '../models/wallet/transaction_summary.dart';
import '../models/wallet/wallet_summary.dart';
import '../models/wallet/withdrawal_response.dart';
import '../services/api_service.dart';

abstract class WalletRepo {
  Future<WalletSummary?> fetchUserWallet();
  Future<List<TransactionItem>?> fetchTransactions();
  Future<WithdrawalResponse?> requestWithdrawal(double amount);
}

class WalletRepoImpl implements WalletRepo {
  final ApiService _apiService;

  WalletRepoImpl({ApiService? service})
    : _apiService = service ?? sl<ApiService>();

  @override
  Future<List<TransactionItem>?> fetchTransactions() async {
    final res = await _apiService.fetchTransactions();
    return res.data;
  }

  @override
  Future<WalletSummary?> fetchUserWallet() async {
    final res = await _apiService.fetchUserWallet();
    return res.data;
  }

  @override
  Future<WithdrawalResponse?> requestWithdrawal(double amount) async {
    final res = await _apiService.requestWithdrawal(amount);
    if (res.data != null) {
      return res.data;
    }
    return null;
  }
}
