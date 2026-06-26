class KycResponse {
  final String? identityStatus;
  final String? licenseStatus;

  //ng kyv setup
  final String? identityRejectionReason;
  final String? licenseRejectionReason;

  KycResponse({
    this.identityStatus,
    this.licenseStatus,

    // ng kyc status
    this.identityRejectionReason,
    this.licenseRejectionReason,
  });

  // Helper getters to clean up UI logic
  bool get isIdentityVerified => identityStatus == 'VERIFIED' || identityStatus == 'APPROVED';
  bool get isIdentityPending => identityStatus == 'PENDING' || identityStatus == 'IN_REVIEW' || identityStatus == 'IN_REVIEW';
  bool get isIdentityRejected => identityStatus == 'FAILED' || identityStatus == 'REJECTED';

  bool get isLicenseVerified => licenseStatus == 'VERIFIED' || licenseStatus == 'APPROVED';
  bool get isLicensePending => licenseStatus == 'PENDING' || licenseStatus == 'IN_REVIEW' || licenseStatus == 'REVIEW';
  bool get isLicenseRejected => licenseStatus == 'FAILED' || licenseStatus == 'REJECTED';

  factory KycResponse.fromJson(Map<String, dynamic> json) {
    return KycResponse(
      identityStatus: json['identityStatus'] as String?,
      licenseStatus: json['licenseStatus'] as String?,

      // ng kyc status
      identityRejectionReason: json['identityRejectionReason'] as String?,
      licenseRejectionReason: json['licenseRejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identityStatus': identityStatus,
      'licenseStatus': licenseStatus,

      // ng kyc status
      'identityRejectionReason': identityRejectionReason,
      'licenseRejectionReason': licenseRejectionReason,
    };
  }
}
