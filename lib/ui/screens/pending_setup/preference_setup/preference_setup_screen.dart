import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryto_driver/ui/widgets/loaders/loading_shimmer.dart';
import 'package:ryto_driver/ui/widgets/texts/header_text.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/enums/action_status.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/customs/custom_action_tile.dart';
import '../../../widgets/customs/svg_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../home/bloc/home_bloc.dart';
import 'bloc/preference_setup_bloc.dart';

class PreferenceSetupScreen extends StatefulWidget {
  const PreferenceSetupScreen({super.key, this.fromDashboard = true});

  final bool fromDashboard;

  @override
  State<PreferenceSetupScreen> createState() => _PreferenceSetupScreenState();
}

class _PreferenceSetupScreenState extends State<PreferenceSetupScreen> {
  // 1. Local State for Toggles
  bool _idCheckRequired = false;
  bool _packagesAllowed = false;
  bool _smokingAllowed = false;
  bool _musicAllowed = false;
  bool _petsAllowed = false;

  @override
  void initState() {
    super.initState();
    // 2. Trigger Fetch on Init
    context.read<PreferenceSetupBloc>().add(FetchPreferences());
  }

  void _onSave() {
    // 3. Dispatch Update Event
    context.read<PreferenceSetupBloc>().add(
      SetPreferenceRequested(
        idCheckRequired: _idCheckRequired,
        packagesAllowed: _packagesAllowed,
        smokingAllowed: _smokingAllowed,
        musicAllowed: _musicAllowed,
        petsAllowed: _petsAllowed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferenceSetupBloc, PreferenceSetupState>(
      listener: (context, state) {
        // Handle data being loaded from the server
        if (state is PreferenceLoaded) {
          setState(() {
            _idCheckRequired = state.data.idCheckRequired;
            _packagesAllowed = state.data.packagesAllowed;
            _smokingAllowed = state.data.smokingAllowed;
            _musicAllowed = state.data.musicAllowed;
            _petsAllowed = state.data.petsAllowed;
          });
        }

        if (state is PreferenceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.read<HomeBloc>().add(
            UpdateOnboardingState(
              status: ActionStatus.completed,
              type: OnboardingStep.preference,
            ),
          );

          if(widget.fromDashboard) {
            router.go(Paths.HOME);
          } else {
            router.pop();
          }
        }
      },
      builder: (context, state) {
        if (state is PreferenceLoading) {
          return BaseScaffoldWidget(
            child: Center(
              child: ListView(
                children: [
                  LoadingShimmer(),
                  SizedBox(height: 10),
                  LoadingShimmer(),
                ],
              ),
            ),
          );
        }
        return BaseScaffoldWidget(
          bottomNavBar: BottomAppBar(
            elevation: 3,
            color: Colors.white,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  text: "Save Preferences",
                  isBusy: state is SetPreferenceLoading,
                  onTap: _onSave,
                ),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackArrowHeader(
                  title: "Trip Rules & Preferences",
                  setDefaultPadding: false,
                ),
                const SizedBox(height: 16),

                // ID Check Section
                _buildSafetyCard(),

                const SizedBox(height: 43),
                const HeaderText(
                  label: "Driver Preferences",
                  subText: "Customize your ride experience for this trip.",
                  labelStyle: TextStyle(fontSize: 18),
                  subTextStyle: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),

                // Preference Toggles
                CustomActionTile(
                  leadingIcon: SvgWidget(
                    assetName: AppSvgs.packageFilled,
                    height: 42,
                    width: 42,
                  ),
                  title: "Food allowed",
                  subtitle: const Text(
                    "Accept food or small parcels",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: _buildSwitch(
                    _packagesAllowed,
                    (val) => setState(() => _packagesAllowed = val),
                  ),
                ),
                const SizedBox(height: 8),
                CustomActionTile(
                  leadingIcon: SvgWidget(
                    assetName: AppSvgs.smokingPermissionFilled,
                    height: 42,
                    width: 42,
                  ),
                  title: "Smoking",
                  subtitle: const Text(
                    "Allow smoking inside the vehicle",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: _buildSwitch(
                    _smokingAllowed,
                    (val) => setState(() => _smokingAllowed = val),
                  ),
                ),
                const SizedBox(height: 8),
                CustomActionTile(
                  leadingIcon: SvgWidget(
                    assetName: AppSvgs.musicFilled,
                    height: 42,
                    width: 42,
                  ),
                  title: "Music",
                  subtitle: const Text(
                    "Passengers can play music",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: _buildSwitch(
                    _musicAllowed,
                    (val) => setState(() => _musicAllowed = val),
                  ),
                ),
                const SizedBox(height: 8),
                CustomActionTile(
                  leadingIcon: SvgWidget(
                    assetName: AppSvgs.musicFilled,
                    height: 42,
                    width: 42,
                  ),
                  title: "Pets",
                  subtitle: const Text(
                    "Allow small pets in carriers",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: _buildSwitch(
                    _petsAllowed,
                    (val) => setState(() => _petsAllowed = val),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: .8,
      child: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildSafetyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff137FEC).withOpacity(.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff137FEC).withOpacity(.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgWidget(assetName: AppIcons.guardOutlined),
              const SizedBox(width: 8),
              const Text(
                "ID check required at pickup",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "This is enabled by default to ensure safety on intercity trips.",
          ),
          const SizedBox(height: 16),
          Switch(
            value: _idCheckRequired,
            onChanged: (value) => setState(() => _idCheckRequired = value),
          ),
        ],
      ),
    );
  }
}
