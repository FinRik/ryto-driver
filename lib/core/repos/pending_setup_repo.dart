import 'dart:io';

import '../../app/app_setup_locator.dart';
import '../models/auth/kyc_response.dart';
import '../models/auth/us_kyc_preflight.dart';
import '../models/auth/us_kyc_verification.dart';
import '../models/bank/bank.dart';
import '../models/bank/payout_bank.dart';
import '../models/bank/verify_user_account.dart';
import '../models/preference.dart';
import '../models/vehicle_setup/vehicle_detail.dart';
import '../models/vehicle_setup/vehicle_setup_request.dart';
import '../services/api_service.dart';
import '../services/g_api_service.dart';

abstract class PendingSetupRepo {
  //verification_setup
  Future<KycResponse?> fetchVerificationStatus(
    bool isRegionUS, {
    int? userId,
    String? type,
    String? status,
  });
  // ng verification setup
  Future<KycResponse?> verifyNin({
    required String identityType,
    required String nin,
    required File selfie,
    required File document,
  });
  Future<KycResponse?> verifyLicense({
    required String licenseNumber,
    required String expiryDate,
    required File front,
    required File back,
  });

  // us verification setup
  Future<USKycPreflight?> attemptPreflight({
    required String ssn,
    required String dob,
    required String driverLicenseNumber,
    required String driverLicenseState,
    required String zipcode,
    required File licenseFront,
    required File licenseBack,
  });
  Future<USKycVerification?> verifyUSKyc();

  //vehicle_setup
  Future<bool> addVehicleDetails(VehicleDetailsRequest request);
  Future<bool> addVehicleCapacity(VehicleCapacityRequest request);
  Future<bool> addVehicleDocument({
    required File license,
    required File roadworthiness,
    required File insurance,
    required File photoFront,
    required File photoBack,
    required File photoSide,
    required File photoInterior,
    required File photoOther,
  });
  Future<VehicleDetail?> fetchVehicleDetails();

  //preference_setup
  Future<Preferences?> fetchDriverPreference();
  Future<bool> setDriverPreference({
    required bool idCheckRequired,
    required bool packagesAllowed,
    required bool smokingAllowed,
    required bool musicAllowed,
    required bool petsAllowed,
  });

  /// payout setup
  // ng payout setup
  Future<List<Bank>?> fetchBanks({required String country});
  Future<BankAccountData?> validateUserAccount({
    required String accountNumber,
    required String code,
  });
  Future<bool> setPayoutBank({
    required String bankCode,
    required String bankName,
    required String accountNumber,
  });

  // us payout setup
  Future<String?> setUSRecipient({
    required String contactEmail,
    required String displayName,
    required String entityType,
  });
  Future<bool> setUSPayout({
    required String accountNumber,
    required String routingNumber,
    required String country,
  });
  Future<PayoutBank?> fetchPayoutBanks();
}

class PendingSetupRepoImpl implements PendingSetupRepo {
  final ApiService _apiService;
  final GApiService _gApiService;

  PendingSetupRepoImpl({ApiService? apiService, GApiService? gApiService})
    : _apiService = apiService ?? sl<ApiService>(),
      _gApiService = gApiService ?? sl<GApiService>();

  /// verification_setup
  // ng verification_setup
  @override
  Future<KycResponse?> verifyLicense({
    required String licenseNumber,
    required String expiryDate,
    required File front,
    required File back,
  }) async {
    final res = await _apiService.verifyLicense(
      licenseNumber,
      expiryDate,
      front,
      back,
    );
    return res.data;
  }

  @override
  Future<KycResponse?> verifyNin({
    required String identityType,
    required String nin,
    required File selfie,
    required File document,
  }) async {
    final res = await _apiService.verifyNin(
      identityType,
      nin,
      selfie,
      document,
    );
    return res.data;
  }

  // us kyc flow
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
    final res = await _apiService.attemptUSKyc(
      ssn,
      dob,
      driverLicenseNumber,
      driverLicenseState,
      zipcode,
      licenseFront,
      licenseBack,
    );
    return res.data;
  }

  @override
  Future<USKycVerification?> verifyUSKyc() async {
    final res = await _apiService.verifyUSKyc();
    return res.data;
  }

  @override
  Future<KycResponse?> fetchVerificationStatus(
    bool isRegionUS, {
    int? userId,
    String? type,
    String? status,
  }) async {
    try {
      // 1. Fetch data based on region
      if (isRegionUS) {
        final res = await _apiService.fetchUSKycStatus();
        if (res.code != 200 || res.data == null) return null;

        return KycResponse(
          identityStatus: res.data["identityStatus"],
          licenseStatus: res.data["licenseStatus"],
        );
      }

      // 2. Non-US flow (with safety guard rails for nullable parameters)
      if (userId == null || type == null || status == null) {
        throw ArgumentError(
          'userId, type, and status are required for non-US regions.',
        );
      }

      final res = await _apiService.fetchNGKycStatus(userId, type, status);
      if (res.code != 200 || res.data == null) return null;

      // Mapping the same status to both fields as required by your current API structure
      return KycResponse(
        identityStatus: res.data["status"],
        licenseStatus: res.data["status"],
      );
    } catch (e) {
      // Log the error here depending on your logging framework (e.g., debugPrint, FirebaseCrashlytics)
      return null;
    }
  }

  //vehicle_setup
  @override
  Future<bool> addVehicleDetails(VehicleDetailsRequest request) async {
    final res = await _apiService.addVehicleDetails(request);
    return res.code == 200;
  }

  @override
  Future<bool> addVehicleCapacity(VehicleCapacityRequest request) async {
    final res = await _apiService.addVehicleCapacity(request);
    return res.code == 200;
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
    final res = await _apiService.addVehicleDocument(
      license,
      roadworthiness,
      insurance,
      photoFront,
      photoBack,
      photoSide,
      photoInterior,
      photoOther,
    );
    return res.code == 200;
  }

  //TODO: Update later
  @override
  Future<VehicleDetail?> fetchVehicleDetails() async {
    final res = await _apiService.fetchVehicleDetails();
    return res.data;
  }

  //preference_setup
  @override
  Future<Preferences?> fetchDriverPreference() async {
    final res = await _apiService.fetchDriverPreference();
    return res.data;
  }

  @override
  Future<bool> setDriverPreference({
    required bool idCheckRequired,
    required bool packagesAllowed,
    required bool smokingAllowed,
    required bool musicAllowed,
    required bool petsAllowed,
  }) async {
    final res = await _apiService.setDriverPreference(
      idCheckRequired,
      packagesAllowed,
      smokingAllowed,
      musicAllowed,
      petsAllowed,
    );
    return res.code == 200;
  }

  /// Payout flow
  @override
  Future<PayoutBank?> fetchPayoutBanks() async {
    final result = await _apiService.fetchDriverPayout();
    return result.data;
  }

  //ng payout setup
  @override
  Future<List<Bank>?> fetchBanks({required String country}) async {
    final res = await _gApiService.fetchBanks(country: country);
    return res ?? [];
  }

  @override
  Future<BankAccountData?> validateUserAccount({
    required String accountNumber,
    required String code,
  }) async {
    final res = await _gApiService.validateUserAccount(
      accountNumber: accountNumber,
      code: code,
    );
    return res;
  }

  @override
  Future<bool> setPayoutBank({
    required String bankCode,
    required String bankName,
    required String accountNumber,
  }) async {
    final res = await _apiService.setDriverPayout(
      bankCode,
      bankName,
      accountNumber,
    );
    return res.code == 200;
  }

  // us payout flow
  @override
  Future<String?> setUSRecipient({
    required String contactEmail,
    required String displayName,
    required String entityType,
  }) async {
    final result = await _apiService.setUSRecipient(
      contactEmail,
      displayName,
      entityType,
    );
    if (result.code == 200 || result.code == 201) {
      return result.data["stripeRecipientAccountId"];
    }
    return null;
  }

  // @override
  // Future<List<Bank>?> fetchUSBanks({required String country}) async {
  //   final result = await _gApiService.fetchBanks(country: country);
  //   return result ?? [];
  // }
  //
  // @override
  // Future<BankAccountData?> validateUSAccount({
  //   required String accountNumber,
  //   required String code,
  // }) async {
  //   final res = await _gApiService.validateUserAccount(
  //     accountNumber: accountNumber,
  //     code: code,
  //   );
  //   return res;
  // }

  @override
  Future<bool> setUSPayout({
    required String accountNumber,
    required String routingNumber,
    required String country,
  }) async {
    final result = await _apiService.setUSPayout(
      accountNumber,
      routingNumber,
      country,
    );
    return result.code == 200 || result.code == 201;
  }
}
