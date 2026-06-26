abstract class Routes {
  Routes._();

  static const SPLASH = Paths.SPLASH;
  static const ONBOARDING = "on-boarding";

  //Account Creation
  static const REGISTERACCOUNT = "register-account";
  static const VERIFYPHONENUMBER = "verify-phone-number";
  static const ACCOUNTSETUP = "user-account-setup";

  static const LOGIN = "login";

  //Dashboard layout flow
  static const HOME = "user-dashboard";
  static const TRIPS = "user-trips";
  static const EARNINGS = "user-earnings";
  static const PROFILE = "user-profile";

  //Pending setups flow
  static const VERIFICATIONSETUP = "verification-setup";
  static const VEHICLESETUP = "driver-vehicle-setup";
  static const BACKGROUNDCHECKSETUP = "background-check-setup";
  static const PREFERENCESETUP = "driver-preference-setup";
  static const PAYOUTSETUP = "driver-payout-setup";
  static const USPAYOUTSETUP = "driver-payout-setup-us";

  // Trip Creation flow
  static const SETTRIPROUTE = "set-trip-route";
  static const SETTRIPSCHEDULE = "set-trip-schedule";
  static const SETTRIPCAPACITY = "set-trip-capacity";
  static const SETMETTINGPOINT = "set-meeting-point";
  static const TRIPSUMMARY = "trip-summary";
  static const TRIPSUCCESS = "trip-success";
  static const TRIPDRAFT = "trip-draft";

  // Trips Management
  static const TRIPDETAILS = "trip-details";
  static const PASSENGERBOOKINGAPPROVED = "passenger-booking-approved";
  static const PASSENGERBOOKINGDECLINED = "passenger-booking-declined";
  static const APPROVEDPASSENGER = "approved-passenger-details";
  static const BULKVERIFYPINS = "bulk-verify-pins";

  // Fund Management Flow
  static const WITHDRAWFUND = "withdraw-funds";
  static const WITHDRAWSUCCESS = "withdraw-success";
  static const WITHDRAWDETAIL = "withdraw-detail";
  static const TRANSACTIONS = "transactions";
  static const TRANSACTIONDETAIL = "transaction-detail";

  /// Profile Section
  // KYC flow
  static const VERIFICATIONDASHBOARD = "verification-dashboard";

  // Vehicle Flow
  static const VEHICLEINFORMATION = "driver-vehicle-information";
  static const VEHICLEDOCUMENTS = "driver-vehicle-documents";

  //profile screen
  static const APPSETTINGS = "app-profile";
  static const SETPIN = "set-pin";
  static const CHANGEPASSWORD = "change-password";
  static const SUPPORT = "help-support";
  static const SECURITYANDPRIVACY = "security-privacy";

  //Payout flow
  static const PAYOUTBANKS = "payout-banks";

  static const WEBVIEW = 'webview';
}

abstract class Paths {
  Paths._();
  // main Routes
  static const SPLASH = '/';
  static const ONBOARDING = '/${Routes.ONBOARDING}';

  //User Accounts Creation Flow
  static const REGISTERACCOUNT = "/${Routes.REGISTERACCOUNT}";
  static const VERIFYPHONENUMBER = "/${Routes.VERIFYPHONENUMBER}";
  static const ACCOUNTSETUP = "/${Routes.ACCOUNTSETUP}";

  static const LOGIN = '/${Routes.LOGIN}';

  //Dashboard Layout flow
  static const HOME = '/${Routes.HOME}';
  static const TRIPS = '/${Routes.TRIPS}';
  static const EARNINGS = '/${Routes.EARNINGS}';
  static const PROFILE = '/${Routes.PROFILE}';

  //Pending setups flow
  static const VERIFICATIONSETUP = "/${Routes.VERIFICATIONSETUP}";
  static const VEHICLESETUP = '/${Routes.VEHICLESETUP}';
  static const BACKGROUNDCHECKSETUP = '/${Routes.BACKGROUNDCHECKSETUP}';
  static const PREFERENCESETUP = '/${Routes.PREFERENCESETUP}';
  static const PAYOUTSETUP = '/${Routes.PAYOUTSETUP}';
  static const USPAYOUTSETUP = '/${Routes.USPAYOUTSETUP}';

  // Trip Creation flow
  static const SETTRIPROUTE = '/${Routes.SETTRIPROUTE}';
  static const SETTRIPSCHEDULE = '/${Routes.SETTRIPSCHEDULE}';
  static const SETTRIPCAPACITY = '/${Routes.SETTRIPCAPACITY}';
  static const SETMETTINGPOINT = '/${Routes.SETMETTINGPOINT}';
  static const TRIPSUMMARY = '/${Routes.TRIPSUMMARY}';
  static const TRIPSUCCESS = '/${Routes.TRIPSUCCESS}';
  static const TRIPDRAFT = '/${Routes.TRIPDRAFT}';

  // Trips Management
  static const TRIPDETAILS = "/${Routes.TRIPDETAILS}";
  static const PASSENGERBOOKINGAPPROVED = "/${Routes.PASSENGERBOOKINGAPPROVED}";
  static const PASSENGERBOOKINGDECLINED = "/${Routes.PASSENGERBOOKINGDECLINED}";
  static const APPROVEDPASSENGER = "/${Routes.APPROVEDPASSENGER}";
  static const BULKVERIFYPINS = "/${Routes.BULKVERIFYPINS}";

  // Fund Management Flow
  static const WITHDRAWFUND = "/${Routes.WITHDRAWFUND}";
  static const WITHDRAWSUCCESS = "/${Routes.WITHDRAWSUCCESS}";
  static const WITHDRAWDETAIL = "/${Routes.WITHDRAWDETAIL}";
  static const TRANSACTIONS = "/${Routes.TRANSACTIONS}";
  static const TRANSACTIONDETAIL = "/${Routes.TRANSACTIONDETAIL}";

  ///Profile Flow
  // Verification Flow
  static const VERIFICATIONDASHBOARD = "/${Routes.VERIFICATIONDASHBOARD}";

  // Vehicle Information
  static const VEHICLEINFORMATION = '/${Routes.VEHICLEINFORMATION}';
  static const VEHICLEDOCUMENTS = '/${Routes.VEHICLEDOCUMENTS}';

  //profile screen
  static const APPSETTINGS = "/${Routes.APPSETTINGS}";
  static const SETPIN = "/${Routes.SETPIN}";
  static const CHANGEPASSWORD = "/${Routes.CHANGEPASSWORD}";
  static const SUPPORT = "/${Routes.SUPPORT}";
  static const SECURITYANDPRIVACY = "/${Routes.SECURITYANDPRIVACY}";

  //Payout flow
  static const PAYOUTBANKS = "/${Routes.PAYOUTBANKS}";

  static const WEBVIEW = "/${Routes.WEBVIEW}";
}
