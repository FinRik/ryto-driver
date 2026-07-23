import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_setup_locator.dart';
import '../../../app/res/icons.dart';
import '../../../app/res/svgs.dart';
import '../../../core/enums/action_status.dart';
import '../../../core/repos/regional_manager_repo.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../dialogs/generic_dialog.dart';
import '../../widgets/app_bars/profile_app_bar.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/buttons/disable_dotted_button.dart';
import '../../widgets/customs/custom_action_tile.dart';
import '../../widgets/customs/svg_widget.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';

import '../../widgets/loaders/circular_indicator.dart';
import '../../widgets/texts/header_text.dart';
import '../pending_setup/payout_setup/bloc/payout_setup_bloc.dart';
import '../pending_setup/preference_setup/bloc/preference_setup_bloc.dart';
import '../pending_setup/vehicle_setup/bloc/vehicle_setup_bloc.dart';
import 'bloc/home_bloc.dart';
import 'widgets/daily_trips_widget.dart';
import 'widgets/earnings_summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final region = sl<RegionIdentity>();
  bool get isRegionUS => region.countryCode == "US";

  // Track terminal states locally during the initial boot sequence
  bool _kycChecked = false;
  bool _vehicleChecked = false;
  bool _payoutChecked = false;
  bool _preferenceChecked = false;

  void _checkInitializationComplete(BuildContext context) {
    // If we are in the US, we might need to verify a background check bloc too.
    // Adjust requirements based on regional logic.
    if (_kycChecked &&
        _vehicleChecked &&
        _payoutChecked &&
        _preferenceChecked) {
      context.read<HomeBloc>().add(CompleteOnboardingSyncEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Tell HomeBloc to show global loading screen for onboarding
      context.read<HomeBloc>().add(StartOnboardingSyncEvent());

      // 2. Fetch standard dashboard figures
      context.read<HomeBloc>().add(FetchDashboardDataEvent());
      // 3. Trigger individual background network tasks
      context.read<ProfileBloc>().add(const FCMTokenRequested());
      context.read<ProfileBloc>().add(FetchUserProfile());
      context.read<VehicleSetupBloc>().add(FetchVehicleDetails());
      context.read<PayoutSetupBloc>().add(FetchPayoutRequested());
      context.read<PreferenceSetupBloc>().add(FetchPreferences());
      context.read<HomeBloc>().add(CompleteOnboardingSyncEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      removePadding: false,
      appBar: const ProfileAppBar(height: 80),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) => previous.user != current.user,
            listener: (context, state) {
              final user = state.user;
              if (user == null) return;

              if (!user.isAccountVerified) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => GenericDialog(
                    title: 'Unverified Account',
                    content:
                        'You are yet to verify you account, Please contact support',
                    onButtonPressed: () {
                      // 1. Pop the dialog using its local dialogContext
                      Navigator.of(dialogContext).pop();

                      // 2. Navigate away using the original page context
                      context.go(Paths.HOME);
                    },
                  ),
                );
                return;
              }

              context.read<RegionalManagerRepo>().setRegionManually(
                user.country == "United States" ? "US" : "NG",
              );
              context.read<HomeBloc>().add(
                UpdateOnboardingState(
                  status: user.kycStatus,
                  type: OnboardingStep.verification,
                ),
              );
              _kycChecked = true;
              _checkInitializationComplete(context);
            },
          ),
          BlocListener<VehicleSetupBloc, VehicleSetupState>(
            listener: (context, state) {
              final isLoaded = state.status == VehicleStatus.loaded;
              final isFailure = state.status == VehicleStatus.failure;

              if (isLoaded || isFailure) {
                if (isLoaded && state.vehicleDetails != null) {
                  context.read<HomeBloc>().add(
                    UpdateOnboardingState(
                      status: state.vehicleDetails!.status,
                      type: OnboardingStep.vehicle,
                    ),
                  );
                }
                _vehicleChecked = true;
                _checkInitializationComplete(context);
              }
            },
          ),
          BlocListener<PayoutSetupBloc, PayoutSetupState>(
            listener: (context, state) {
              if (state.fetchStatus == PayoutFetchStatus.success ||
                  state.fetchStatus == PayoutFetchStatus.failure) {
                if (state.fetchStatus == PayoutFetchStatus.success &&
                    state.currentPayout != null) {
                  context.read<HomeBloc>().add(
                    UpdateOnboardingState(
                      status: ActionStatus.completed,
                      type: OnboardingStep.payout,
                    ),
                  );
                }
                _payoutChecked = true;
                _checkInitializationComplete(context);
              }
            },
          ),
          BlocListener<PreferenceSetupBloc, PreferenceSetupState>(
            listener: (context, state) {
              if (state is PreferenceLoaded || state is PreferenceFailure) {
                if (state is PreferenceLoaded) {
                  context.read<HomeBloc>().add(
                    UpdateOnboardingState(
                      status: ActionStatus.completed,
                      type: OnboardingStep.preference,
                    ),
                  );
                }
                _preferenceChecked = true;
                _checkInitializationComplete(context);
              }
            },
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.onboardingStatus == OnboardingFetchStatus.loading ||
                state.onboardingStatus == OnboardingFetchStatus.initial) {
              return const Scaffold(
                body: Center(
                  child: CircularIndicator(bgColor: Color(0xffCCE21D)),
                ),
              );
            }

            final totalEarnings =
                state.dailyEarnings?.todayEarnings.toString() ?? "0";
            final tripsCount = state.tripsCount ?? 0;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchDashboardDataEvent());
                // 3. Trigger individual background network tasks
                context.read<ProfileBloc>().add(FetchUserProfile());
                context.read<VehicleSetupBloc>().add(FetchVehicleDetails());
                context.read<PayoutSetupBloc>().add(FetchPayoutRequested());
                context.read<PreferenceSetupBloc>().add(FetchPreferences());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!state.isFullyOnboarded(region.countryCode)) ...[
                      const HeaderText(
                        label: "Finish Your Setup",
                        subText:
                            "Complete these steps to start earning on the platform.",
                        subTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),

                      // 1. KYC Action Tile
                      CustomActionTile(
                        leadingIcon: SvgWidget(assetName: AppSvgs.guard),
                        title: "Verify Your Identity (KYC)",
                        subtitle: StatusIndicator(status: state.verification),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            router.push(Paths.VERIFICATIONSETUP, extra: true),
                      ),
                      const SizedBox(height: 8),

                      // 2. Vehicle Action Tile
                      CustomActionTile(
                        leadingIcon: SvgWidget(assetName: AppSvgs.driver),
                        title: "Add Vehicle Information",
                        subtitle: StatusIndicator(status: state.vehicle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          if (state.vehicle == ActionStatus.completed ||
                              state.vehicle == ActionStatus.pending) {
                            router.push(Paths.VEHICLEINFORMATION);
                          } else {
                            router.push(Paths.VEHICLESETUP);
                          }
                        },
                      ),

                      // 3. Conditional Background Check (US only)
                      if (isRegionUS) ...[
                        const SizedBox(height: 8),
                        CustomActionTile(
                          leadingIcon: SvgWidget(assetName: AppSvgs.preference),
                          title: "Background Check",
                          subtitle: StatusIndicator(status: state.background),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => router.push(Paths.BACKGROUNDCHECKSETUP),
                        ),
                      ],
                      const SizedBox(height: 8),

                      // 4. Preferences Action Tile
                      CustomActionTile(
                        leadingIcon: SvgWidget(assetName: AppSvgs.preference),
                        title: "Set Preference",
                        subtitle: StatusIndicator(status: state.preference),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            router.push(Paths.PREFERENCESETUP, extra: true),
                      ),
                      const SizedBox(height: 8),

                      // 5. Payout Action Tile
                      CustomActionTile(
                        leadingIcon: SvgWidget(assetName: AppSvgs.bankFiled),
                        title: "Set Payout",
                        subtitle: StatusIndicator(status: state.payout),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          if (state.payout == ActionStatus.completed ||
                              state.payout == ActionStatus.pending) {
                            router.push(Paths.PAYOUTBANKS);
                          } else {
                            router.push(
                              isRegionUS
                                  ? Paths.USPAYOUTSETUP
                                  : Paths.PAYOUTSETUP,
                              extra: false,
                            );
                          }
                        },
                      ),
                    ],
                    if (state.isFullyOnboarded(region.countryCode)) ...[
                      EarningsSummaryCard(
                        amount: totalEarnings,
                        tripsCompleted: tripsCount,
                        hours: 0.0,
                      ),
                    ],

                    // 2. Main Action Button
                    if (!state.isFullyOnboarded(region.countryCode)) ...[
                      const SizedBox(height: 48),
                      CreateTripPlaceholder(),
                      const SizedBox(height: 11),
                      const Text(
                        "You'll be able to create trips once your profile is verified.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 65),
                    ],
                    if (state.isFullyOnboarded(region.countryCode)) ...[
                      const SizedBox(height: 32),
                      Button(
                        text: 'Create a Trip',
                        onTap: () => router.push(Paths.SETTRIPROUTE),
                        showPrefixIcon: true,
                        icon: (Icons.add_circle),
                        textColor: const Color(0xff222328),
                        buttonColor: const Color(0xffCCE21D),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // 3. Section Header
                    if (!state.isFullyOnboarded(region.countryCode)) ...[
                      Center(
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffF1F5F9),
                          ),
                          child: Center(
                            child: SvgWidget(assetName: AppIcons.documentText),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const HeaderText(
                        padding: EdgeInsets.zero,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        label: "Getting things ready...",
                        subText:
                            "Your upcoming trips and passenger requests will appear here as soon as your account is approved and active.",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        subTextStyle: TextStyle(fontSize: 14),
                        centerSubtitle: true,
                      ),
                      const SizedBox(height: 40),
                    ],
                    if (state.isFullyOnboarded(region.countryCode)) ...[
                      DailyTripsWidget(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final ActionStatus status;
  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: status.color),
        const SizedBox(width: 6),
        Text(status.label, style: TextStyle(color: status.color)),
      ],
    );
  }
}
