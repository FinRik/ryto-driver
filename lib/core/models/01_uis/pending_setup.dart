import 'package:flutter/material.dart';

import '../../../ui/screens/pending_setup/vehicle_setup/parts/add_vehicle.dart';
import '../../../ui/screens/pending_setup/vehicle_setup/parts/add_vehicle_capacity.dart';
import '../../../ui/screens/pending_setup/vehicle_setup/parts/add_vehicle_docs.dart';
import '../../../ui/screens/pending_setup/verification_setup/parts/01_verification_overview.dart';
import '../../../ui/screens/pending_setup/verification_setup/parts/02_ng_identity_verification.dart';
import '../../../ui/screens/pending_setup/verification_setup/parts/03_us_identity_verification.dart';
import '../../../ui/screens/pending_setup/verification_setup/parts/04_license_verification.dart';

class PendingSetup {
  final String title;
  final String? subText;
  final Widget Function(PageController) pageBuilder;
  final String btnText;

  PendingSetup({
    required this.title,
    this.subText,
    required this.pageBuilder,
    required this.btnText,
  });

  static List<PendingSetup> vehicleListView = [
    PendingSetup(
      title: "Add Vehicle",
      subText: "Add Vehicle Details",
      pageBuilder: (pc) => AddVehicle(controller: pc),
      btnText: "Continue to capacity",
    ),
    PendingSetup(
      title: "Capacity",
      pageBuilder: (pc) => AddVehicleCapacity(controller: pc),
      btnText: "Save Capacity",
    ),
    PendingSetup(
      title: "Vehicle Doc & Verification",
      pageBuilder: (pc) => AddVehicleDocs(controller: pc),
      btnText: "Upload & Continue",
    ),
  ];
  
  static List<PendingSetup> ngKycListView = [
    PendingSetup(
      title: "Verification Overview",
      pageBuilder: (pc) => VerificationDashboard(pageController: pc),
      btnText: "Start Verification",
    ),
    PendingSetup(
      title: "Identity Verification",
      subText: "Nigeria (NG) Driver Profile",
      pageBuilder: (pc) => NGIdentityVerification(pageController: pc),
      btnText: "Submit Document",
    ),
    PendingSetup(
      title: "Driver's License",
      subText: "Secure Identity Verification",
      pageBuilder: (pc) => LicenseVerification(pageController: pc),
      btnText: "Submit Document",
    ),
    // PendingSetup(
    //   title: "",
    //   pageBuilder: (pc) => VerificationStatus(pageController: pc),
    //   btnText: "Go to dashboard",
    // ),
  ];
  static List<PendingSetup> usKycListView = [
    PendingSetup(
      title: "Verification Overview",
      pageBuilder: (pc) => VerificationDashboard(pageController: pc),
      btnText: "Start Verification",
    ),
    PendingSetup(
      title: "Identity Verification",
      subText: "United States (US) Driver Profile",
      pageBuilder: (pc) => USIdentityVerification(pageController: pc),
      btnText: "Submit Document",
    ),
    PendingSetup(
      title: "Driver's License",
      subText: "Secure Identity Verification",
      pageBuilder: (pc) => LicenseVerification(pageController: pc),
      btnText: "Submit Document",
    ),
    // PendingSetup(
    //   title: "",
    //   pageBuilder: (pc) => VerificationStatus(pageController: pc),
    //   btnText: "Go to dashboard",
    // ),
  ];
}