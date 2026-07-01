import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/layout/bottom_nav/bottom_nav.dart';
import '../../ui/screens/account_setup/account_setup_screen.dart';
import '../../ui/screens/app_webview.dart';
import '../../ui/screens/auth/ui/login/login_screen.dart';
import '../../ui/screens/auth/ui/sign_up/sign_up_screen.dart';
import '../../ui/screens/auth/ui/verify_phone/verify_phone_number_screen.dart';
import '../../ui/screens/draft/trip_drafts_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/pending_setup/background_check_setup/background_check_setup.dart';
import '../../ui/screens/pending_setup/payout_setup/us_payout_setup_screen.dart';
import '../../ui/screens/pending_setup/vehicle_setup/vehicle_document_screen.dart';
import '../../ui/screens/pending_setup/verification_setup/verification_setup_screen.dart';
import '../../ui/screens/profile/settings/settings_screen.dart';
import '../../ui/screens/profile/change_password_screen.dart';
import '../../ui/screens/profile/help_support_screen.dart';
import '../../ui/screens/profile/security/security_privacy_screen.dart';
import '../../ui/screens/profile/set_pin_screen.dart';
import '../../ui/screens/trip_action/booking_approved_screen.dart';
import '../../ui/screens/trip_action/booking_declined_screen.dart';
import '../../ui/screens/trips/trip_details_screen.dart';
import '../../ui/screens/trip_action/approved_passenger_screen.dart';
import '../../ui/screens/trip_setup/04_trip_meeting_points_screen.dart';
import '../../ui/screens/trip_setup/03_trip_capacity_screen.dart';
import '../../ui/screens/trip_setup/01_trip_route_screen.dart';
import '../../ui/screens/trip_setup/02_trip_schedule_screen.dart';
import '../../ui/screens/trip_setup/06_trip_success_screen.dart';
import '../../ui/screens/trip_setup/05_trip_summary_screen.dart';
import '../../ui/screens/onboarding/onboarding_screen.dart';
import '../../ui/screens/pending_setup/payout_setup/payout_banks.dart';
import '../../ui/screens/pending_setup/payout_setup/payout_setup_screen.dart';
import '../../ui/screens/pending_setup/preference_setup/preference_setup_screen.dart';
import '../../ui/screens/pending_setup/vehicle_setup/vehicle_information_screen.dart';
import '../../ui/screens/pending_setup/vehicle_setup/vehicle_setup_screen.dart';
import '../../ui/screens/profile_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/trips/trips_screen.dart';
import '../../ui/screens/trips/verify_pin_screen.dart';
import '../../ui/screens/wallet/transactions/transactions_details_screen.dart';
import '../../ui/screens/wallet/transactions/transactions_screen.dart';
import '../../ui/screens/wallet/withdrawal/03_withdrawal_detail_screen.dart';
import '../../ui/screens/wallet/wallet_screen.dart';
import '../../ui/screens/wallet/withdrawal/01_withdrawal_screen.dart';
import '../../ui/screens/wallet/withdrawal/02_withdrawal_success_screen.dart';
import '../models/bookings/booking_summary.dart';
import '../models/trip/trip.dart';
import '../models/trip/trip_summary.dart';
import '../models/vehicle_setup/vehicle_detail.dart';
import '../models/wallet/withdrawal_response.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
// final scaffoldKey = GlobalKey<ScaffoldState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
BuildContext? get rootContext => _rootNavigatorKey.currentContext;

final router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  restorationScopeId: "app",
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.SPLASH,
      name: Routes.SPLASH,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.ONBOARDING,
      name: Routes.ONBOARDING,
      builder: (context, state) => const OnboardingScreen(),
    ),

    //Account Creation Floe
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.REGISTERACCOUNT,
      name: Routes.REGISTERACCOUNT,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: Paths.VERIFYPHONENUMBER,
      name: Routes.VERIFYPHONENUMBER,
      builder: (context, state) =>
          VerifyPhoneNumberScreen(args: state.extra as VerifyOtpArgs),
    ),
    GoRoute(
      path: Paths.ACCOUNTSETUP,
      name: Routes.ACCOUNTSETUP,
      builder: (context, state) => AccountSetupScreen(),
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.LOGIN,
      name: Routes.LOGIN,
      builder: (context, state) => const LoginScreen(),
    ),

    //Dashboard Layout Flow
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) => BottomNavLayout(child: child),
      routes: [
        GoRoute(
          path: Paths.HOME,
          name: Routes.HOME,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Paths.TRIPS,
          name: Routes.TRIPS,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TripsScreen(),
        ),
        GoRoute(
          path: Paths.EARNINGS,
          name: Routes.EARNINGS,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const WalletScreen(),
        ),
        GoRoute(
          path: Paths.PROFILE,
          name: Routes.PROFILE,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    //Pending setups flow
    GoRoute(
      path: Paths.VERIFICATIONSETUP,
      name: Routes.VERIFICATIONSETUP,
      builder: (context, state) =>
          VerificationSetupScreen(isDashboard: state.extra as bool),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.VEHICLESETUP,
      name: Routes.VEHICLESETUP,
      builder: (context, state) => VehicleSetupScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.BACKGROUNDCHECKSETUP,
      name: Routes.BACKGROUNDCHECKSETUP,
      builder: (context, state) => BackgroundCheckScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PREFERENCESETUP,
      name: Routes.PREFERENCESETUP,
      builder: (context, state) =>
          PreferenceSetupScreen(fromDashboard: state.extra as bool),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PAYOUTSETUP,
      name: Routes.PAYOUTSETUP,
      builder: (context, state) =>
          PayoutSetupScreen(onPopRefresh: state.extra as bool),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.USPAYOUTSETUP,
      name: Routes.USPAYOUTSETUP,
      builder: (context, state) =>
          USPayoutSetupScreen(onPopRefresh: state.extra as bool),
    ),

    // Trip Creation flow
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SETTRIPROUTE,
      name: Routes.SETTRIPROUTE,
      builder: (context, state) => SetTripRouteScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SETTRIPSCHEDULE,
      name: Routes.SETTRIPSCHEDULE,
      builder: (context, state) => SetTripScheduleScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SETTRIPCAPACITY,
      name: Routes.SETTRIPCAPACITY,
      builder: (context, state) => SetTripCapacityScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SETMETTINGPOINT,
      name: Routes.SETMETTINGPOINT,
      builder: (context, state) => SetMeetingPointsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRIPSUMMARY,
      name: Routes.TRIPSUMMARY,
      builder: (context, state) => TripSummaryScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRIPSUCCESS,
      name: Routes.TRIPSUCCESS,
      builder: (context, state) =>
          TripSuccessScreen(isDraft: state.extra as bool),
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRIPDRAFT,
      name: Routes.TRIPDRAFT,
      builder: (context, state) => TripDraftsListScreen(),
    ),

    //Trip Management
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRIPDETAILS,
      name: Routes.TRIPDETAILS,
      builder: (context, state) => TripDetailsScreen(trip: state.extra as Trip),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.APPROVEDPASSENGER,
      name: Routes.APPROVEDPASSENGER,
      builder: (context, state) => ApprovedPassengerScreen(
        args: state.extra as PassengerDetailsArgs,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PASSENGERBOOKINGAPPROVED,
      name: Routes.PASSENGERBOOKINGAPPROVED,
      builder: (context, state) =>
          BookingApprovedScreen(args: state.extra as PassengerDetailsArgs),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PASSENGERBOOKINGDECLINED,
      name: Routes.PASSENGERBOOKINGDECLINED,
      builder: (context, state) =>
          RequestDeclinedScreen(bookingSummary: state.extra as BookingSummary),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.BULKVERIFYPINS,
      name: Routes.BULKVERIFYPINS,
      builder: (context, state) =>
          TripBulkPinVerificationScreen(tripId: state.extra as String),
    ),

    // Fund Management Flow
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.WITHDRAWFUND,
      name: Routes.WITHDRAWFUND,
      builder: (context, state) => WithdrawalScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.WITHDRAWSUCCESS,
      name: Routes.WITHDRAWSUCCESS,
      builder: (context, state) => WithdrawalSuccessScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.WITHDRAWDETAIL,
      name: Routes.WITHDRAWDETAIL,
      builder: (context, state) => WithdrawalDetailScreen(
        withdrawalResponse: state.extra as WithdrawalResponse,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRANSACTIONS,
      name: Routes.TRANSACTIONS,
      builder: (context, state) => TransactionsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.TRANSACTIONDETAIL,
      name: Routes.TRANSACTIONDETAIL,
      builder: (context, state) =>
          TransactionDetailsScreen(transactionId: state.extra as int),
    ),

    ///Profile Flow
    // Verification Flow
    GoRoute(
      path: Paths.VERIFICATIONDASHBOARD,
      name: Routes.VERIFICATIONDASHBOARD,
      builder: (context, state) =>
          VerificationSetupScreen(isDashboard: state.extra as bool),
    ),
    // Vehicle Information
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.VEHICLEINFORMATION,
      name: Routes.VEHICLEINFORMATION,
      builder: (context, state) => VehicleInformationScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.VEHICLEDOCUMENTS,
      name: Routes.VEHICLEDOCUMENTS,
      builder: (context, state) =>
          VehicleDocumentsScreen(vehicle: state.extra as VehicleDetail),
    ),
    // Settings screen
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.APPSETTINGS,
      name: Routes.APPSETTINGS,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SETPIN,
      name: Routes.SETPIN,
      builder: (context, state) => const SetPinScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.CHANGEPASSWORD,
      name: Routes.CHANGEPASSWORD,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SUPPORT,
      name: Routes.SUPPORT,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.SECURITYANDPRIVACY,
      name: Routes.SECURITYANDPRIVACY,
      builder: (context, state) => const SecurityPrivacyScreen(),
    ),

    //Payout flow
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.PAYOUTBANKS,
      name: Routes.PAYOUTBANKS,
      builder: (context, state) => const PayoutBankInfoScreen(),
    ),

    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Paths.WEBVIEW,
      name: Routes.WEBVIEW,
      builder: (context, state) => AppWebview(args: state.extra as WebviewArgs),
    ),

    //Package Booking Route
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.ADDPACKAGEDETAIL,
    //   name: Routes.ADDPACKAGEDETAIL,
    //   builder: (context, state) => const AddPackageDetailScreen(),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.CONFIRMPACKAGEDETAIL,
    //   name: Routes.CONFIRMPACKAGEDETAIL,
    //   builder: (context, state) =>
    //       ConfirmPackageSelectScreen(listItem: state.extra as PackageSizeModel),
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.PACKAGEBOOKINGSUMMARY,
    //   name: Routes.PACKAGEBOOKINGSUMMARY,
    //   builder: (context, state) => PackageBookingSummaryScreen(),
    // ),
    //
    // //Booking history Route
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Paths.BOOKINGHISTORYDETAIL,
    //   name: Routes.BOOKINGHISTORYDETAIL,
    //   builder: (context, state) =>
    //       BookingDetailsScreen(trip: state.extra as Trip),
    // ),
  ],
);

// extension GoRouterExt on GoRouter {
//   String get _currentRouteName => routerDelegate.currentConfiguration.last.route.name ?? "";
//
//   void popUntil(String routeName) {
//     var currentRouteName = _currentRouteName;
//     while (currentRouteName != routeName && currentRouteName.isNotEmpty && canPop()) {
//       pop();
//       currentRouteName = _currentRouteName;
//     }
//   }
// }

class VerifyOtpArgs {
  final String phone;
  final bool isLogin;

  VerifyOtpArgs({required this.phone, required this.isLogin});
}

class PassengerDetailsArgs {
  final BookingSummary bookingSummary;
  final TripSummary tripSummary;

  PassengerDetailsArgs({
    required this.bookingSummary,
    required this.tripSummary,
  });
}

class WebviewArgs {
  final String? title;
  final String url;

  WebviewArgs({this.title, required this.url});
}

// class EmptyStateArgs {
//   const EmptyStateArgs({this.title, this.subtitle, this.image, this.btnText});
//
//   final String? title;
//   final String? image;
//   final String? subtitle;
//   final String? btnText;
// }
//
// // class ServiceArgs {
// //   const ServiceArgs({
// //     required this.title,
// //     required this.model,
// //   });
// //
// //   final String title;
// //   final ServiceViewModel model;
// // }
//
// class ProfileSubMenuArgs {
//   final String title;
//   final List<ActionModel>? list;
//
//   ProfileSubMenuArgs({required this.title, this.list});
// }
//
// class TransactionArgs<T> {
//   final T data;
//
//   TransactionArgs({required this.data});
// }
