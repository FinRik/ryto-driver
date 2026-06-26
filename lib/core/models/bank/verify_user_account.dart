class VerifyUserAccount {
  final bool status;
  final String message;
  final BankAccountData? data;

  VerifyUserAccount({
    required this.status,
    required this.message,
    this.data,
  });

  factory VerifyUserAccount.fromJson(Map<String, dynamic> json) {
    return VerifyUserAccount(
      status: json['status'],
      message: json['message'],
      data: BankAccountData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class BankAccountData {
  final String accountNumber;
  final String accountName;
  final int bankId;

  BankAccountData({
    required this.accountNumber,
    required this.accountName,
    required this.bankId,
  });

  factory BankAccountData.fromJson(Map<String, dynamic> json) {
    return BankAccountData(
      accountNumber: json['account_number'],
      accountName: json['account_name'],
      bankId: json['bank_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_id': bankId,
    };
  }
}