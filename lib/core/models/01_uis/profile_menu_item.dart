import '../../../app/res/icons.dart';
import '../../enums/action_status.dart';
import '../../routes/routes.dart';

class ProfileMenuItem {
  final String icon;
  final String title;
  final String? subtitle;         // e.g. "OTB•013*****89" or "Toyata Camry - AA-LSR-123"
  // final String status;            // "PENDING", "COMPLETED", "" (empty = normal)
  final bool isChevronShown;      // most items have → , some might not
  final String route;
  final ActionStatus status;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    // this.status = "",
    this.isChevronShown = true,
    required this.route,
    required this.status
  });

  static final List<ProfileMenuItem> profileItems = [
    ProfileMenuItem(
      icon: AppIcons.contactCard,
      title: "KYC Verification",
      subtitle: "Identity and license documents",
      route: Paths.VERIFICATIONDASHBOARD,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.vehicle,
      title: "Vehicle Information",
      subtitle: "Verified vehicle information",
      // subtitle: "Toyota Camry - AA-LSR-123",
      route: Paths.VEHICLEINFORMATION,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.bank,
      title: "Payout Information",
      subtitle: "Bank account information",
      // subtitle: "OTB•013*****89",
      route: Paths.PAYOUTBANKS,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.settings,
      title: "Trip Preferences",
      subtitle: "Smoking, Pets, AC, Music",
      route: Paths.PREFERENCESETUP,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.contactCard,
      title: "Trip Drafts",
      subtitle: "Access unpublished trips",
      route: Paths.TRIPDRAFT,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.security,
      title: "Security Settings",
      subtitle: "Account Management",
      // subtitle: "PIN, Biometrics, Password",
      route: Paths.SECURITYANDPRIVACY,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.gear,
      title: "App Settings",
      subtitle: "Notifications, Language",
      route: Paths.APPSETTINGS,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.help,
      title: "Help & Support",
      subtitle: "FAQ, Legal",
      route: Paths.SUPPORT,
      status: ActionStatus.notSet,
    ),
    ProfileMenuItem(
      icon: AppIcons.help,
      title: "Contact Support",
      subtitle: "Contact us",
      route: "openSupportSheet",
      status: ActionStatus.notSet,
    ),
  ];
}