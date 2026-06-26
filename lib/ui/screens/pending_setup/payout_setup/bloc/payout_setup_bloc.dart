import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/bank/bank.dart';
import '../../../../../core/models/bank/payout_bank.dart';
import '../../../../../core/repos/pending_setup_repo.dart';

part 'payout_setup_event.dart';
part 'payout_setup_state.dart';

class PayoutSetupBloc extends Bloc<PayoutSetupEvent, PayoutSetupState> {
  final PendingSetupRepo repo;

  PayoutSetupBloc(this.repo) : super(const PayoutSetupState()) {
    // Fetch Current Payout Details
    on<FetchPayoutRequested>((event, emit) async {
      emit(state.copyWith(fetchStatus: PayoutFetchStatus.loading));
      try {
        final result = await repo.fetchPayoutBanks();
        emit(
          state.copyWith(
            fetchStatus: PayoutFetchStatus.success,
            currentPayout: result,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            fetchStatus: PayoutFetchStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    // Fetch List of Banks
    on<FetchBanksRequested>((event, emit) async {
      emit(state.copyWith(fetchStatus: PayoutFetchStatus.loading));
      try {
        final banks = await repo.fetchBanks(country: "Nigeria");
        emit(
          state.copyWith(
            fetchStatus: PayoutFetchStatus.success,
            banks: banks ?? [],
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            fetchStatus: PayoutFetchStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    // Validate Account (Part of Setup Flow)
    on<ValidateBankAccountRequested>((event, emit) async {
      emit(state.copyWith(ngPayoutSetup: NGPayoutSetup.validating));
      try {
        final accountData = await repo.validateUserAccount(
          accountNumber: event.accountNumber,
          code: event.bankCode,
        );
        emit(
          state.copyWith(
            ngPayoutSetup: NGPayoutSetup.validated,
            validatedAccountName: accountData?.accountName,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            ngPayoutSetup: NGPayoutSetup.failure,
            errorMessage: "Validation failed: ${e.toString()}",
          ),
        );
      }
    });

    // Set/Update Payout
    on<SetPayoutRequested>((event, emit) async {
      emit(state.copyWith(ngPayoutSetup: NGPayoutSetup.loading));
      try {
        final success = await repo.setPayoutBank(
          bankCode: event.bankCode,
          bankName: event.bankName,
          accountNumber: event.accountNumber,
        );
        if (success) {
          emit(
            state.copyWith(
              ngPayoutSetup: NGPayoutSetup.success,
              successMessage: "Bank account linked successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              ngPayoutSetup: NGPayoutSetup.failure,
              errorMessage: "Failed to update bank details",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            ngPayoutSetup: NGPayoutSetup.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    //us
    on<SetUSRecipientRequested>((event, emit) async {
      emit(state.copyWith(usPayoutSetup: USPayoutSetup.loading));
      try {
        final recipientId = await repo.setUSRecipient(
          contactEmail: event.contactEmail,
          displayName: event.displayName,
          entityType: event.entityType,
        );
        if (recipientId != null) {
          emit(
            state.copyWith(
              usPayoutSetup: USPayoutSetup.recipientSuccess,
              currentPayout: state.currentPayout?.copyWith(
                stripeRecipientAccountId: recipientId,
              ),
              successMessage: "Bank account linked successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              usPayoutSetup: USPayoutSetup.recipientFailure,
              errorMessage: "Failed to set US recipient details",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            usPayoutSetup: USPayoutSetup.recipientFailure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<SetUSPayoutRequested>((event, emit) async {
      emit(state.copyWith(usPayoutSetup: USPayoutSetup.loading));
      try {
        final success = await repo.setUSPayout(
          accountNumber: event.accountNumber,
          routingNumber: event.routingNumber,
          country: event.country,
        );
        if (success) {
          emit(
            state.copyWith(
              usPayoutSetup: USPayoutSetup.success,
              successMessage: "US Payout method linked successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              usPayoutSetup: USPayoutSetup.failure,
              errorMessage: "Failed to update US payout details",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            usPayoutSetup: USPayoutSetup.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
