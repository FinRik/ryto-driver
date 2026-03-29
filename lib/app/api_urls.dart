class ApiUrls {
  // static const String baseUrl = "https://api.getryto.com/api";
  static const String baseUrl = "https://api.getryto.com";

  static const String login = "/auth/driver/login/phone";
  static const String register = "/auth/driver/signup/phone";
  static const String verifyOtp = "/auth/driver/verify/phone";
  static const String resendOtp = "/auth/driver/resend-phone-verification";
  static const String updateProfilePic = "auth/driver/profile-picture";
  static const String updateProfile = "/auth/driver/complete-profile";
  static const String verifyNin = "/kyc/driver/identity";
  static const String verifyLicense = "/kyc/driver/license";
  static const String verificationStatus = "/kyc/driver/status";
  static const String addVehicleDetails = "/vehicle/driver/details";
  static const String addVehicleCapacity = "/vehicle/driver/capacity";
  static const String addVehicleDocument = "/vehicle/driver/docs-and-photos";
  static const String fetchVehicleDetails = "/vehicle/driver/me";
  static const String fetchDriverPreference = "/driver/trip/preferences";
  static const String setDriverPreference = "/driver/trip/preferences";
  static const String fetchDriverPayout = "/driver/payout-method";
  static const String setDriverPayout = "/driver/payout-method";

  static const String walletDetails = "/driver/wallet/summary";
  static const String transactions = "/driver/wallet/transactions";
}