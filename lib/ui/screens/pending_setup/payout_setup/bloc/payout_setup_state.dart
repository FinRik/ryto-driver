part of 'payout_setup_bloc.dart';

enum PayoutFetchStatus { initial, loading, success, failure }
enum NGPayoutSetup { initial, loading, validating, validated, success, failure }
enum USPayoutSetup { initial, loading, recipientSuccess, success, recipientFailure, failure }

class PayoutSetupState extends Equatable {
  final PayoutFetchStatus fetchStatus;
  final NGPayoutSetup ngPayoutSetup;
  final USPayoutSetup usPayoutSetup;

  // Data containers
  final List<Bank> banks;
  final PayoutBank? currentPayout;
  final String? validatedAccountName;

  // Feedback
  final String? errorMessage;
  final String? successMessage;

  const PayoutSetupState({
    this.fetchStatus = PayoutFetchStatus.initial,
    this.ngPayoutSetup = NGPayoutSetup.initial,
    this.usPayoutSetup = USPayoutSetup.initial,
    this.banks = const [],
    this.currentPayout,
    this.validatedAccountName,
    this.errorMessage,
    this.successMessage,
  });

  PayoutSetupState copyWith({
    PayoutFetchStatus? fetchStatus,
    NGPayoutSetup? ngPayoutSetup,
    USPayoutSetup? usPayoutSetup,
    List<Bank>? banks,
    PayoutBank? currentPayout,
    String? validatedAccountName,
    String? errorMessage,
    String? successMessage,
  }) {
    return PayoutSetupState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      ngPayoutSetup: ngPayoutSetup ?? this.ngPayoutSetup,
      usPayoutSetup: usPayoutSetup ?? this.usPayoutSetup,
      banks: banks ?? this.banks,
      currentPayout: currentPayout ?? this.currentPayout,
      validatedAccountName: validatedAccountName ?? this.validatedAccountName,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    fetchStatus,
    ngPayoutSetup,
    usPayoutSetup,
    banks,
    currentPayout,
    validatedAccountName,
    errorMessage,
    successMessage
  ];
}