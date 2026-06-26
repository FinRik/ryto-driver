part of 'payout_setup_bloc.dart';

abstract class PayoutSetupEvent extends Equatable {
  const PayoutSetupEvent();

  @override
  List<Object?> get props => [];
}

class FetchPayoutRequested extends PayoutSetupEvent {}

class RefreshPayoutRequested extends PayoutSetupEvent {}

class FetchBanksRequested extends PayoutSetupEvent {}

class ValidateBankAccountRequested extends PayoutSetupEvent {
  final String accountNumber;
  final String bankCode;

  const ValidateBankAccountRequested({
    required this.accountNumber,
    required this.bankCode,
  });

  @override
  List<Object?> get props => [accountNumber, bankCode];
}

class SetPayoutRequested extends PayoutSetupEvent {
  final String bankCode;
  final String bankName;
  final String accountNumber;

  const SetPayoutRequested({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
  });

  @override
  List<Object?> get props => [bankCode, bankName, accountNumber];
}

// us
class SetUSRecipientRequested extends PayoutSetupEvent {
  final String contactEmail;
  final String displayName;
  final String entityType; // e.g., 'individual' or 'company'

  const SetUSRecipientRequested({
    required this.contactEmail,
    required this.displayName,
    required this.entityType,
  });

  @override
  List<Object?> get props => [contactEmail, displayName, entityType];
}

class SetUSPayoutRequested extends PayoutSetupEvent {
  final String accountNumber;
  final String routingNumber;
  final String country;

  const SetUSPayoutRequested({
    required this.accountNumber,
    required this.routingNumber,
    required this.country,
  });

  @override
  List<Object?> get props => [accountNumber, routingNumber, country];
}