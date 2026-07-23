class ApiUrls {
  ApiUrls._();

  static const String baseUrl = "https://api.getryto.com";
  // static const String imageBaseUrl = "https://getryto.com";
  static const String countryBaseUrl = "https://countriesnow.space/api/v0.1";
  static const String paystackBaseUrl = "https://api.paystack.co";

  static const String states = "/countries/states";
  // static const String cities = "/countries/state/cities";
  static const String cities = "/countries";

  static const String locationUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const String placeDetailsUrl =
      "https://maps.googleapis.com/maps/api/place/details/json";

  // socials
  static const String instagram = "https://www.instagram.com/rytoapp";
  static const String facebook =
      "https://www.facebook.com/share/16xszJZNrY/?mibextid=wwXIfr";
  static const String tiktok = "https://www.tiktok.com/@rytoapp";
  static const String linkedIn = "https://www.linkedin.com/company/rytoapp/";
  static const String twitter = "https://www.x.com/rytoapp";
  static const String faq = "https://getryto.com/faqs";
  static const String privacy = "https://getryto.com/privacy";
  static const String terms = "https://getryto.com/terms";
  static const String website = "https://getryto.com";
  static const String deleteAccount = "https://getryto.com/delete-account";

  // auth flow
  static const String login = "/auth/driver/login/phone";
  static const String register = "/auth/driver/signup/phone";
  static const String verifyLogin = "/auth/driver/verify-login";
  static const String verifyOtp = "/auth/driver/verify/phone";
  static const String resendOtp = "/auth/driver/resend-phone-verification";

  // User profile flow
  static const String updateProfilePic = "/auth/driver/profile-picture";
  static const String updateProfile = "/auth/driver/complete-profile";
  static const String fetchProfile = "/auth/driver/user";

  // fcm/push notif
  static const String updateFCMToken = "/auth/driver/push-token";
  static const String deleteFCMToken = "/auth/driver/push-token";

  /// KYC flow
  // ng kyc flow
  static const String verifyNin = "/kyc/driver/identity";
  static const String verifyLicense = "/kyc/driver/license";
  // us kyc flow
  static const String attemptUSKyc = "/kyc/driver/us/preflight";
  static const String verifyUSKyc = "/kyc/driver/us/verification-session/native";
  // kyc status
  static const String usKycStatus = "/kyc/driver/status";
  static const String ngKycStatus = "/kyc/driver/webhook";

  static const String addVehicleDetails = "/vehicle/driver/details";
  static const String addVehicleCapacity = "/vehicle/driver/capacity";
  static const String addVehicleDocument = "/vehicle/driver/docs-and-photos";
  static const String fetchVehicleDetails = "/vehicle/driver/me";
  static const String fetchPreference = "/driver/trip/preferences";
  static const String setPreference = "/driver/trip/preferences";
  ///Payouts
  static const String fetchPayout = "/driver/payout-method";
  // ng payout setup
  static const String fetchNGBanks = "/bank";
  static const String validateNGBank = "/bank/resolve";
  static const String setNGPayout = "/driver/payout-method";
  // us payout setup
  static const String setUSRecipient = "/driver/payout-method/us/recipient";
  static const String fetchUSBanks = "/bank";
  static const String validateUSBank = "/bank/resolve";
  static const String setUSPayout = "/driver/payout-method/us/bank";

  // Wallet flow
  static const String walletDetails = "/driver/wallet/summary";
  static const String transactions = "/driver/wallet/transactions";
  static const String withdraw = "/driver/payout/request";

  static const String tripCost = "/booking/summary";
  static const String createTrip = "/driver/trips";

  // trips flow
  static const String trips = "/driver/trips";
  static const String tripsCount = "/driver/trips/stats/completed-count";
  static const String tripSummary = "/driver/trips/{id}/summary";
  static const String tripBookingSummary = "/driver/trips/{tripId}/bookings";
  static const String acceptTripBooking =
      "/driver/trips/{tripId}/bookings/{bookingId}/accept";
  // static const String declineTripBooking =
  //     "/driver/trips/{tripId}/bookings/{bookingId}/reject";
  static const String declineTripBooking = "/booking/cancel/driver";
  static const String completeTrip = "/driver/trips/{id}/complete";
  static const String cancelTrip = "/driver/trips/{id}/cancel";
  static const String verityPassengerPins = "/driver/trips/{id}/verify-safety-pins";
}