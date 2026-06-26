part of 'verification_setup_bloc.dart';

enum KycStatus { initial, loading, success, failure }
enum NgKycStep { initial, loading, success, failure }
enum UsKycStep { initial, loading, preflightSuccess, success, failure }

class VerificationSetupState extends Equatable {
  final KycStatus kycStatus;
  final NgKycStep ngKycStep;
  final UsKycStep usKycStep;
  final String? errorMessage;
  // KYC Status Responses
  final KycResponse? kycResponse;
  // NG verification responses
  final KycResponse? identityResponse;
  final KycResponse? licenseResponse;
  // US Form Draft Data
  final USPreflightRequest? preflightRequest;
  // US API Responses
  final USKycPreflight? preflightResponse;
  final USKycVerification? verificationResponse;

  const VerificationSetupState({
    this.kycStatus = KycStatus.initial,
    this.ngKycStep = NgKycStep.initial,
    this.usKycStep = UsKycStep.initial,
    this.errorMessage,
    this.kycResponse,
    //ng flow
    this.identityResponse,
    this.licenseResponse,
    //us flow
    this.preflightRequest,
    this.preflightResponse,
    this.verificationResponse,
  });

  VerificationSetupState copyWith({
    KycStatus? kycStatus,
    NgKycStep? ngKycStep,
    UsKycStep? usKycStep,
    String? Function()? errorMessage, // Use a function callback pattern if you ever need to explicitly pass null for fields
    KycResponse? kycResponse,
    // NG verification flow
    KycResponse? identityResponse,
    KycResponse? licenseResponse,
    // US verification flow
    USPreflightRequest? preflightRequest,
    USKycPreflight? preflightResponse,
    USKycVerification? verificationResponse,
  }) {
    return VerificationSetupState(
      kycStatus: kycStatus ?? this.kycStatus,
      ngKycStep: ngKycStep ?? this.ngKycStep,
      usKycStep: usKycStep ?? this.usKycStep,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      kycResponse: kycResponse ?? this.kycResponse,
      // NG verification flow
      identityResponse: identityResponse ?? this.identityResponse,
      licenseResponse: licenseResponse ?? this.licenseResponse,
      // US verification flow
      preflightRequest: preflightRequest ?? this.preflightRequest,
      preflightResponse: preflightResponse ?? this.preflightResponse,
      verificationResponse: verificationResponse ?? this.verificationResponse,
    );
  }

  @override
  List<Object?> get props => [
    kycStatus,
    ngKycStep,
    usKycStep,
    errorMessage,
    kycResponse,
    // NG verification flow
    licenseResponse,
    identityResponse,
    // US verification flow
    preflightRequest,
    preflightResponse,
    verificationResponse,
  ];
}