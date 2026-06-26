part of 'verification_setup_bloc.dart';

abstract class VerificationSetupEvent extends Equatable {
  const VerificationSetupEvent();

  @override
  List<Object?> get props => [];
}

class VerificationStatusRequested extends VerificationSetupEvent {
  final bool isRegionUS;
  final int? userId;
  final String? type;
  final String? status;

  const VerificationStatusRequested({
    required this.isRegionUS,
    this.userId,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [isRegionUS, userId, type, status];
}

// ng kyc events
class VerifyNinRequested extends VerificationSetupEvent {
  final String identityType;
  final String nin;
  final File selfie;
  final File document;

  const VerifyNinRequested({
    required this.identityType,
    required this.nin,
    required this.selfie,
    required this.document,
  });

  @override
  List<Object?> get props => [identityType, nin, selfie, document];
}

class VerifyLicenseRequested extends VerificationSetupEvent {
  final String licenseNumber;
  final String expiryDate;
  final File front;
  final File back;

  const VerifyLicenseRequested({
    required this.licenseNumber,
    required this.expiryDate,
    required this.front,
    required this.back,
  });

  @override
  List<Object?> get props => [licenseNumber, expiryDate, front, back];
}

class SaveUsIdentityDraft extends VerificationSetupEvent {
  final String? ssn;
  final String? dob;
  final String? driverLicenseState;
  final String? zipcode;
  final String? driverLicenseNumber;
  final File? licenseFront;
  final File? licenseBack;

  const SaveUsIdentityDraft({
    this.ssn,
    this.dob,
    this.driverLicenseState,
    this.zipcode,
    this.driverLicenseNumber,
    this.licenseFront,
    this.licenseBack,
  });

  @override
  List<Object?> get props => [
    ssn,
    dob,
    driverLicenseState,
    zipcode,
    driverLicenseNumber,
    licenseFront,
    licenseBack,
  ];
}

class PreflightRequested extends VerificationSetupEvent {
  const PreflightRequested();

  @override
  List<Object?> get props => [];
}

class VerifyUsKycRequested extends VerificationSetupEvent {
  const VerifyUsKycRequested();

  @override
  List<Object?> get props => [];
}
