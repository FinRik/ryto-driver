import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pending_setup/vehicle_setup/bloc/vehicle_setup_bloc.dart';
import '../../widgets/inputs/place_suggestion_widget.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../../app/app_setup_locator.dart';
import '../../widgets/trip_route_map.dart';
import '../../widgets/buttons/button.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import 'widgets/route_indicator.dart';
import 'bloc/trip_setup_bloc.dart';

class SetTripRouteScreen extends StatefulWidget {
  const SetTripRouteScreen({super.key});

  @override
  State<SetTripRouteScreen> createState() => _SetTripRouteScreenState();
}

class _SetTripRouteScreenState extends State<SetTripRouteScreen> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  LatLng? _origin;
  LatLng? _destination;

  void _getVehicleId() {
    if (!mounted) return;

    final vehicleState = context.read<VehicleSetupBloc>().state;

    if (vehicleState.status != VehicleStatus.loaded ||
        vehicleState.vehicleDetails == null) {
      router.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No vehicle info was found")),
      );
      return;
    }

    _updateRegionAndVehicle(vehicleState.vehicleDetails!.id);
  }

  void _updateRegionAndVehicle(int vehicleId) {
    final region = sl<RegionIdentity>();
    final tripSetupBloc = context.read<TripSetupBloc>();
    final tripState = tripSetupBloc.state;

    final newDraft = tripState.draft.copyWith(
      vehicleId: vehicleId,
      country: region.country,
      currency: region.currencyCode,
    );

    tripSetupBloc.add(UpdateTripDraft(newDraft));
  }

  void _updateLocation({
    required bool isOrigin,
    required double lat,
    required double lng,
    required String address,
  }) {
    final bloc = context.read<TripSetupBloc>();
    final newDraft = isOrigin
        ? bloc.state.draft.copyWith(
      originCity: address,
      originLat: lat,
      originLng: lng,
    )
        : bloc.state.draft.copyWith(
      destinationCity: address,
      destinationLat: lat,
      destinationLng: lng,
    );

    bloc.add(UpdateTripDraft(newDraft));
    if (isOrigin == true) {
      _origin = LatLng(lat: lat, lng: lng);
    } else {
      _destination = LatLng(lat: lat, lng: lng);
    }
  }

  void _swapLocations() {
    final bloc = context.read<TripSetupBloc>();
    final draft = bloc.state.draft;

    // Nothing meaningful to swap if both are empty.
    if (draft.originLat == null && draft.destinationLat == null) return;

    final newDraft = draft.copyWith(
      originCity: draft.destinationCity,
      originLat: draft.destinationLat,
      originLng: draft.destinationLng,
      destinationCity: draft.originCity,
      destinationLat: draft.originLat,
      destinationLng: draft.originLng,
    );

    bloc.add(UpdateTripDraft(newDraft));

    setState(() {
      // Swap text controllers.
      final tempText = _originController.text;
      _originController.text = _destinationController.text;
      _destinationController.text = tempText;

      // Swap cached LatLngs used by the map.
      final tempLatLng = _origin;
      _origin = _destination;
      _destination = tempLatLng;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _getVehicleId()
    );
    super.initState();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripSetupBloc, TripSetupState>(
      builder: (context, state) {
        return BaseScaffoldWidget(
          removePadding: true,
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.all(12.0),
              child: BackArrowButton(),
            ),
            title: const Text(
              "Set Trip Route",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2559),
              ),
            ),
            centerTitle: true,
          ),
          child: GestureDetector(
            // Tapping outside the fields dismisses the keyboard.
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                TripRouteMap(
                  olat: _origin?.lat,
                  olng: _origin?.lng,
                  dlat: _destination?.lat,
                  dlng: _destination?.lng,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40, right: 40),
                              child: Column(
                                children: [
                                  _buildAutocompleteField(
                                    controller: _originController,
                                    label: "ORIGIN CITY",
                                    hint: "Enter origin",
                                    isOrigin: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildAutocompleteField(
                                    controller: _destinationController,
                                    label: "DESTINATION CITY",
                                    hint: "Where to?",
                                    isOrigin: false,
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              left: 0,
                              top: 25,
                              bottom: 25,
                              child: RouteIndicator(),
                            ),
                            // Swap button on the right side of the fields.
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Material(
                                  color: const Color(0xff137FEC).withOpacity(.10),
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: _swapLocations,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.swap_vert,
                                        size: 20,
                                        color: const Color(0xff137FEC),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xff137FEC).withOpacity(.10),
                            borderRadius: BorderRadius.circular(48),
                            border: Border.all(
                              color: const Color(0xff137FEC).withOpacity(.20),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Color(0xff137FEC)),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Selecting popular routes increases your chances of finding passengers quickly.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xff137FEC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Button(
                      text: "Set Date & Time",
                      showSuffixIcon: true,
                      onTap: () {
                        if (state.draft.originLat != null &&
                            state.draft.destinationLat != null) {
                          router.push(Paths.SETTRIPSCHEDULE);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isOrigin,
  }) {
    return PlacesSuggestionWidget(
      hint: hint,
      label: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
      controller: controller,
      prefixIcon: null,
      onPlaceSelected: (place) async {
        _updateLocation(
          isOrigin: isOrigin,
          lat: place.lat,
          lng: place.lng,
          address: place.address!,
        );
      },
    );
  }
}