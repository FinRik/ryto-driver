import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/auth/kyc_response.dart';
import '../../../../../core/models/auth/us_kyc_preflight.dart';
import '../../../../../core/models/auth/us_kyc_verification.dart';
import '../../../../../core/models/auth/us_preflight_request.dart';
import '../../../../../core/repos/pending_setup_repo.dart';

part 'verification_setup_event.dart';
part 'verification_setup_state.dart';

class VerificationSetupBloc
    extends Bloc<VerificationSetupEvent, VerificationSetupState> {
  final PendingSetupRepo _repo;

  VerificationSetupBloc(this._repo) : super(const VerificationSetupState()) {
    // --- GLOBAL FLOWS ---

    on<VerificationStatusRequested>((event, emit) async {
      emit(
        state.copyWith(kycStatus: KycStatus.loading, errorMessage: () => null),
      );
      try {
        final response = await _repo.fetchVerificationStatus(
          event.isRegionUS,
          userId: event.userId,
          type: event.type,
          status: event.status,
        );
        if (response != null) {
          emit(
            state.copyWith(
              kycStatus: KycStatus.success,
              kycResponse: response,
              errorMessage: () => null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              kycStatus: KycStatus.failure,
              errorMessage: () => "Failed to fetch status",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            kycStatus: KycStatus.failure,
            errorMessage: () => e.toString(),
          ),
        );
      }
    });

    // --- NG KYC FLOWS ---
    on<VerifyNinRequested>((event, emit) async {
      emit(
        state.copyWith(ngKycStep: NgKycStep.loading, errorMessage: () => null),
      );
      try {
        final identityResponse = await _repo.verifyNin(
          identityType: event.identityType,
          nin: event.nin,
          selfie: event.selfie,
          document: event.document,
        );
        if (identityResponse != null) {
          emit(
            state.copyWith(
              ngKycStep: NgKycStep.success,
              identityResponse: identityResponse,
            ),
          );
        } else {
          emit(
            state.copyWith(
              ngKycStep: NgKycStep.failure,
              errorMessage: () => "NIN verification failed",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            ngKycStep: NgKycStep.failure,
            errorMessage: () => e.toString(),
          ),
        );
      }
    });

    on<VerifyLicenseRequested>((event, emit) async {
      emit(
        state.copyWith(ngKycStep: NgKycStep.loading, errorMessage: () => null),
      );
      try {
        final licenseResponse = await _repo.verifyLicense(
          licenseNumber: event.licenseNumber,
          expiryDate: event.expiryDate,
          front: event.front,
          back: event.back,
        );
        if (licenseResponse != null) {
          emit(
            state.copyWith(
              ngKycStep: NgKycStep.success,
              licenseResponse: licenseResponse,
            ),
          );
        } else {
          emit(
            state.copyWith(
              ngKycStep: NgKycStep.failure,
              errorMessage: () => "License verification failed",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            ngKycStep: NgKycStep.failure,
            errorMessage: () => e.toString(),
          ),
        );
      }
    });

    // --- US KYC FLOWS ---

    // US Step 1: Cache Draft Data locally in the BLoC state
    on<SaveUsIdentityDraft>((event, emit) async {
      // 1. Get the current request data if it exists, or establish a baseline empty/default one
      // (Note: This assumes you might want to make USPreflightRequest fields nullable
      // or provide default values like empty strings to allow partial initialization)
      final currentRequest =
          state.preflightRequest ??
          USPreflightRequest(
            ssn: '',
            dob: '',
            driverLicenseNumber: '',
            driverLicenseState: '',
            zipcode: '',
            licenseFront: File(''),
            licenseBack: File(''),
          );

      // 2. Progressive merge: update only what the current screen sent us
      final updatedRequest = currentRequest.copyWith(
        ssn: event.ssn,
        dob: event.dob,
        driverLicenseState: event.driverLicenseState,
        zipcode: event.zipcode,
        driverLicenseNumber: event.driverLicenseNumber,
        licenseFront: event.licenseFront,
        licenseBack: event.licenseBack,
      );

      print("Preflight request: ${updatedRequest.ssn}");

      emit(
        state.copyWith(
          usKycStep: UsKycStep.initial,
          errorMessage: () => null,
          preflightRequest: updatedRequest,
        ),
      );
    });

    // US Step 2: Fire the Preflight API call using cached state data
    on<PreflightRequested>((event, emit) async {
      // Defensive Check: Ensure we actually have data to send
      if (state.preflightRequest == null) {
        emit(
          state.copyWith(
            usKycStep: UsKycStep.failure,
            errorMessage: () =>
                "No draft data found. Please complete Step 1 first.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(usKycStep: UsKycStep.loading, errorMessage: () => null),
      );

      try {
        // Unwrapping variables cleanly from our state object
        final requestData = state.preflightRequest!;

        final preflight = await _repo.attemptPreflight(
          ssn: requestData.ssn,
          dob: requestData.dob,
          driverLicenseState: requestData.driverLicenseState,
          zipcode: requestData.zipcode,
          driverLicenseNumber: requestData.driverLicenseNumber,
          licenseFront: requestData.licenseFront,
          licenseBack: requestData.licenseBack,
        );

        if (preflight != null) {
          emit(
            state.copyWith(
              usKycStep: UsKycStep.preflightSuccess,
              preflightResponse: preflight,
            ),
          );
        } else {
          emit(
            state.copyWith(
              usKycStep: UsKycStep.failure,
              errorMessage: () => "US Preflight registration failed.",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            usKycStep: UsKycStep.failure,
            errorMessage: () => e.toString(),
          ),
        );
      }
    });

    // US Step 3: Trigger Final Server Verification
    on<VerifyUsKycRequested>((event, emit) async {
      // Defensive Check: Ensure Step 1 was actually successful before finalizing
      if (state.preflightResponse == null) {
        emit(
          state.copyWith(
            usKycStep: UsKycStep.failure,
            errorMessage: () =>
                "Preflight response is missing. Cannot verify identity.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(usKycStep: UsKycStep.loading, errorMessage: () => null),
      );

      try {
        // If your repo needs data from Step 1 (e.g., a reference ID or the preflight payload),
        // you can easily pass it here like: state.preflightResponse!.id
        final result = await _repo.verifyUSKyc();

        if (result != null) {
          emit(
            state.copyWith(
              usKycStep: UsKycStep.success,
              verificationResponse: result,
            ),
          );
        } else {
          emit(
            state.copyWith(
              usKycStep: UsKycStep.failure,
              errorMessage: () => "US KYC Final Verification failed.",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            usKycStep: UsKycStep.failure,
            errorMessage: () => e.toString(),
          ),
        );
      }
    });
  }
}
