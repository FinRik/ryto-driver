import 'dart:io';

import '../../models/auth/kyc_response.dart';
import '../../models/auth/us_kyc_preflight.dart';
import '../../models/auth/us_kyc_verification.dart';
import '../../models/bank/bank.dart';
import '../../models/bank/payout_bank.dart';
import '../../models/bank/verify_user_account.dart';
import '../../models/preference.dart';
import '../../models/vehicle_setup/vehicle_detail.dart';
import '../../models/vehicle_setup/vehicle_setup_request.dart';
import '../pending_setup_repo.dart';

class MockPendingSetupRepoImpl implements PendingSetupRepo {
  bool shouldFail = false;

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (shouldFail) {
      throw Exception("Simulated network error occurred.");
    }
  }

  // ===========================================================================
  // VERIFICATION SETUP
  // ===========================================================================

  @override
  Future<KycResponse?> fetchVerificationStatus(
    bool isRegionUS, {
    int? userId,
    String? type,
    String? status,
  }) async {
    await _simulateNetworkDelay();
    return KycResponse(identityStatus: "APPROVED", licenseStatus: "APPROVED");
  }

  @override
  Future<USKycPreflight?> attemptPreflight({
    required String ssn,
    required String dob,
    required String driverLicenseNumber,
    required String driverLicenseState,
    required String zipcode,
    required File licenseFront,
    required File licenseBack,
  }) async {
    await _simulateNetworkDelay();
    return USKycPreflight(
      licenseFrontUrl: "https://example.com/storage/license_front_mock.jpg",
      licenseBackUrl: "https://example.com/storage/license_back_mock.jpg",
    );
  }

  @override
  Future<USKycVerification?> verifyUSKyc() async {
    await _simulateNetworkDelay();
    // Assuming this returns the keys Stripe requires for step 2
    return USKycVerification(
      verificationSessionId: "vi_mock_${DateTime.now().millisecondsSinceEpoch}",
      ephemeralKeySecret:
          "ek_mock_secret_${DateTime.now().microsecondsSinceEpoch}",
    );
  }

  @override
  Future<KycResponse?> verifyNin({
    required String identityType,
    required String nin,
    required File selfie,
    required File document,
  }) async {
    await _simulateNetworkDelay();

    // Trigger a rejection if the NIN contains '000'
    if (nin.contains('000')) {
      return KycResponse(
        identityStatus: 'REJECTED',
        identityRejectionReason: 'The blurred selfie does not match the image on your NIN slip.',
      );
    }

    // Trigger a pending state if the NIN contains '111'
    if (nin.contains('111')) {
      return KycResponse(identityStatus: 'PENDING');
    }

    // Default to success
    return KycResponse(identityStatus: 'VERIFIED');
  }

  @override
  Future<KycResponse?> verifyLicense({
    required String licenseNumber,
    required String expiryDate,
    required File front,
    required File back,
  }) async {
    await _simulateNetworkDelay();

    // Trigger a rejection if the license number contains '000'
    if (licenseNumber.contains('000')) {
      return KycResponse(
        licenseStatus: 'REJECTED',
        licenseRejectionReason: 'Driver\'s license has expired or is invalid.',
      );
    }

    if (licenseNumber.contains('111')) {
      return KycResponse(licenseStatus: 'PENDING');
    }

    return KycResponse(licenseStatus: 'VERIFIED');
  }

  // ===========================================================================
  // VEHICLE SETUP
  // ===========================================================================

  @override
  Future<bool> addVehicleDetails(VehicleDetailsRequest request) async {
    await _simulateNetworkDelay();
    return true;
  }

  @override
  Future<bool> addVehicleCapacity(VehicleCapacityRequest request) async {
    await _simulateNetworkDelay();
    return true;
  }

  @override
  Future<bool> addVehicleDocument({
    required File license,
    required File roadworthiness,
    required File insurance,
    required File photoFront,
    required File photoBack,
    required File photoSide,
    required File photoInterior,
    required File photoOther,
  }) async {
    await _simulateNetworkDelay();
    return true;
  }

  @override
  Future<VehicleDetail?> fetchVehicleDetails() async {
    await _simulateNetworkDelay();
    return VehicleDetail(
      id: 101,
      userId: 12,
      type: "Sedan",
      serviceTier: "Premium",
      makeModel: "Tesla Model Y",
      year: 2024,
      color: "Solid Black",
      plateNumber: "MOCK-77-XYZ",
      passengerSeats: 4,
      frontSeatAvailable: true,
      loadSmallPackages: true,
      loadMediumLoads: true,
      loadLargeLoads: false,
      storageLocation: "Trunk & Frunk",
      verificationStatus: "VERIFIED",
      licenseImageUrl: "https://example.com/files/lic.png",
      roadworthinessImageUrl: "https://example.com/files/road.png",
      insuranceImageUrl: "https://example.com/files/ins.png",
      photoFrontUrl: "https://example.com/files/front.png",
      photoBackUrl: "https://example.com/files/back.png",
      photoSideUrl: null,
      photoInteriorUrl: null,
      photoOtherUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    );
  }

  // ===========================================================================
  // PREFERENCE SETUP
  // ===========================================================================

  @override
  Future<Preferences?> fetchDriverPreference() async {
    await _simulateNetworkDelay();
    return Preferences(
      idCheckRequired: true,
      packagesAllowed: true,
      smokingAllowed: false,
      musicAllowed: true,
      petsAllowed: false,
    );
  }

  @override
  Future<bool> setDriverPreference({
    required bool idCheckRequired,
    required bool packagesAllowed,
    required bool smokingAllowed,
    required bool musicAllowed,
    required bool petsAllowed,
  }) async {
    await _simulateNetworkDelay();
    return true;
  }

  // ===========================================================================
  // PAYOUT SETUP
  // ===========================================================================

  @override
  Future<List<Bank>?> fetchBanks({required String country}) async {
    await _simulateNetworkDelay();
    return [
      Bank(name: "Mock National Bank", code: "MNB001"),
      Bank(name: "Apex Global Bank", code: "AGB002"),
    ];
  }

  @override
  Future<BankAccountData?> validateUserAccount({
    required String accountNumber,
    required String code,
  }) async {
    await _simulateNetworkDelay();
    return BankAccountData(
      accountNumber: accountNumber,
      accountName: "Johnathan Doe",
      bankId: 44, // Fixed mapping matching your exact constructor
    );
  }

  @override
  Future<bool> setPayoutBank({
    required String bankCode,
    required String bankName,
    required String accountNumber,
  }) async {
    await _simulateNetworkDelay();
    return true;
  }

  @override
  Future<String?> setUSRecipient({
    required String contactEmail,
    required String displayName,
    required String entityType,
  }) async {
    await _simulateNetworkDelay();
    return "rec_mock_stripe_12345";
  }

  @override
  Future<bool> setUSPayout({
    required String accountNumber,
    required String routingNumber,
    required String country,
  }) async {
    await _simulateNetworkDelay();
    return true;
  }

  @override
  Future<PayoutBank?> fetchPayoutBanks() async {
    await _simulateNetworkDelay();
    return PayoutBank(
      id: 999,
      userId: 12,
      bankName: "Stripe Test Bank",
      bankCode: "STRIPE01",
      accountNumber: "******6789",
      accountName: "Johnathan Doe",
      country: "US",
      currency: "USD",
      provider: "stripe",
      stripeConnectAccountId: "acct_mock_connect_id",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
