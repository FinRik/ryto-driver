import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/buttons/back_arrow_header.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/customs/event_state_widgets.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/loading_shimmer.dart';
import '../../../widgets/more_info_widget.dart';
import 'bloc/vehicle_setup_bloc.dart';
import 'widgets/vehicle_card_widget.dart';
import 'widgets/spec_tile.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({super.key});

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchVehicleDetails()
    );
  }

  void _fetchVehicleDetails(){
    context.read<VehicleSetupBloc>().add(
      FetchVehicleDetails()
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BaseScaffoldWidget(
  //     bgColor: Colors.white,
  //     // bottomNavBar: _buildBottomNav(state),
  //     child: BlocBuilder<VehicleSetupBloc, VehicleSetupState>(
  //       builder: (context, state) {
  //         switch (state.status) {
  //           case VehicleStatus.initial:
  //             return const SizedBox.shrink();
  //           case VehicleStatus.loading:
  //             return Center(child: LoadingShimmer());
  //           case VehicleStatus.failure:
  //             return ErrorStateWidget(
  //               message: state.error ?? "Unknown Error please try again",
  //               onRetry: _fetchVehicleDetails,
  //             );
  //           case VehicleStatus.success:
  //           case VehicleStatus.loaded:
  //             if (state.status == VehicleStatus.loaded) {
  //               final vehicle = state.vehicleDetails;
  //
  //               if (vehicle == null) {
  //                 return EmptyStateWidget(
  //                   onTap: _fetchVehicleDetails,
  //                   title: "Not Found!",
  //                   subtitle: "Vehicle details not found",
  //                 );
  //               }
  //
  //               return SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     BackArrowHeader(
  //                       title: "Identity Verification",
  //                       setDefaultPadding: false,
  //                     ),
  //                     const SizedBox(height: 29),
  //                     VehicleCardWidget(vehicle: vehicle),
  //                     const SizedBox(height: 24),
  //
  //                     // --- Specifications Section ---
  //                     CustomCardWidget(
  //                       title: "Specifications".toUpperCase(),
  //                       disableBorder: true,
  //                       padding: EdgeInsets.zero,
  //                       titleStyle: const TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14,
  //                         color: Color(0xff696E7E),
  //                       ),
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey.shade200),
  //                           borderRadius: BorderRadius.circular(16),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             SpecTile(
  //                               icon: Icons.directions_car,
  //                               label: "Make & Model",
  //                               value: vehicle.makeModel, // Fixed field name
  //                             ),
  //                             SpecTile(
  //                               icon: Icons.category,
  //                               label: "Service Tier",
  //                               value: vehicle.serviceTier,
  //                             ),
  //                             SpecTile(
  //                               icon: Icons.calendar_today,
  //                               label: "Year",
  //                               value: vehicle.year.toString(),
  //                             ),
  //                             SpecTile(
  //                               icon: Icons.palette_outlined,
  //                               label: "Color",
  //                               value: vehicle.color,
  //                             ),
  //                             SpecTile(
  //                               icon: Icons.confirmation_number_outlined,
  //                               label: "Plate Number",
  //                               value: vehicle.plateNumber, // Fixed field name
  //                             ),
  //                             SpecTile(
  //                               icon: Icons.event_seat,
  //                               label: "Seats",
  //                               value: "${vehicle.passengerSeats} Seats",
  //                               isLast: true,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 24),
  //
  //                     // --- Cargo/Load Capabilities ---
  //                     Text(
  //                       "LOAD CAPABILITIES",
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14,
  //                         color: Color(0xff696E7E),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Wrap(
  //                       spacing: 8,
  //                       children: [
  //                         if (vehicle.loadSmallPackages) _buildChip(
  //                             "Small Loads"),
  //                         if (vehicle.loadMediumLoads) _buildChip(
  //                             "Medium Loads"),
  //                         if (vehicle.loadLargeLoads) _buildChip("Large Loads"),
  //                       ],
  //                     ),
  //
  //                     const SizedBox(height: 24),
  //
  //                     // --- Documents/Photos Section ---
  //                     // if (vehicle.formattedPhotoFrontUrl.isNotEmpty) ...[
  //                     //   Text(
  //                     //     "VEHICLE PHOTOS",
  //                     //     style: TextStyle(
  //                     //       fontWeight: FontWeight.w600,
  //                     //       fontSize: 14,
  //                     //       color: Color(0xff696E7E),
  //                     //     ),
  //                     //   ),
  //                     //   const SizedBox(height: 12),
  //                     //   SizedBox(
  //                     //     height: 100,
  //                     //     child: ListView(
  //                     //       scrollDirection: Axis.horizontal,
  //                     //       children: [
  //                     //         _buildImagePreview(
  //                     //           vehicle.formattedPhotoFrontUrl,
  //                     //           "Front",
  //                     //         ),
  //                     //         _buildImagePreview(
  //                     //           vehicle.formattedPhotoBackUrl,
  //                     //           "Back",
  //                     //         ),
  //                     //         _buildImagePreview(
  //                     //           vehicle.formattedPhotoInteriorUrl,
  //                     //           "Interior",
  //                     //         ),
  //                     //       ],
  //                     //     ),
  //                     //   ),
  //                     // ],
  //
  //                     // --- Documents/Photos Section ---
  //                     // Use null-safe checks. (Assuming you fix the model in Step 2 to return a String?)
  //                     if (vehicle.formattedPhotoFrontUrl != null &&
  //                         vehicle.formattedPhotoFrontUrl!.isNotEmpty) ...[
  //                       Text(
  //                         "VEHICLE PHOTOS",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 14,
  //                           color: Color(0xff696E7E),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 12),
  //                       SizedBox(
  //                         height: 100,
  //                         child: ListView(
  //                           scrollDirection: Axis.horizontal,
  //                           children: [
  //                             if (vehicle.formattedPhotoFrontUrl != null &&
  //                                 vehicle.formattedPhotoFrontUrl!.isNotEmpty)
  //                               _buildImagePreview(
  //                                 vehicle.formattedPhotoFrontUrl,
  //                                 "Front",
  //                               ),
  //
  //                             if (vehicle.formattedPhotoBackUrl != null &&
  //                                 vehicle.formattedPhotoBackUrl!.isNotEmpty)
  //                               _buildImagePreview(
  //                                 vehicle.formattedPhotoBackUrl,
  //                                 "Back",
  //                               ),
  //
  //                             if (vehicle.formattedPhotoInteriorUrl != null &&
  //                                 vehicle.formattedPhotoInteriorUrl!.isNotEmpty)
  //                               _buildImagePreview(
  //                                 vehicle.formattedPhotoInteriorUrl,
  //                                 "Interior",
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //
  //                     const SizedBox(height: 24),
  //                     const MoreInfoWidget(
  //                       text:
  //                       "Changes to vehicle details may require a new verification process.",
  //                       iconColor: Color(0xff0066FF),
  //                       textColor: Color(0xff0066FF),
  //                     ),
  //                     const SizedBox(height: 40),
  //                   ],
  //                 ),
  //               );
  //         }
  //       }
  // }
  //         }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      bgColor: Colors.white,
      child: BlocBuilder<VehicleSetupBloc, VehicleSetupState>(
        builder: (context, state) {
          switch (state.status) {
            case VehicleStatus.initial:
              return const SizedBox.shrink();

            case VehicleStatus.loading:
              return Center(child: LoadingShimmer());

            case VehicleStatus.failure:
              return ErrorStateWidget(
                message: state.error ?? "Unknown Error please try again",
                onRetry: _fetchVehicleDetails,
              );

            case VehicleStatus.success:
              return Center(child: LoadingShimmer());

            case VehicleStatus.loaded:
              final vehicle = state.vehicleDetails;

              if (vehicle == null) {
                return EmptyStateWidget(
                  onTap: _fetchVehicleDetails,
                  title: "Not Found!",
                  subtitle: "Vehicle details not found",
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackArrowHeader(
                      title: "Identity Verification",
                      setDefaultPadding: false,
                    ),
                    const SizedBox(height: 29),
                    VehicleCardWidget(vehicle: vehicle),
                    const SizedBox(height: 24),

                    // --- Specifications Section ---
                    CustomCardWidget(
                      title: "Specifications".toUpperCase(),
                      disableBorder: true,
                      padding: EdgeInsets.zero,
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff696E7E),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            SpecTile(
                              icon: Icons.directions_car,
                              label: "Make & Model",
                              value: vehicle.makeModel,
                            ),
                            SpecTile(
                              icon: Icons.category,
                              label: "Service Tier",
                              value: vehicle.serviceTier,
                            ),
                            SpecTile(
                              icon: Icons.calendar_today,
                              label: "Year",
                              value: vehicle.year.toString(),
                            ),
                            SpecTile(
                              icon: Icons.palette_outlined,
                              label: "Color",
                              value: vehicle.color,
                            ),
                            SpecTile(
                              icon: Icons.confirmation_number_outlined,
                              label: "Plate Number",
                              value: vehicle.plateNumber,
                            ),
                            SpecTile(
                              icon: Icons.event_seat,
                              label: "Seats",
                              value: "${vehicle.passengerSeats} Seats",
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Cargo/Load Capabilities ---
                    Text(
                      "LOAD CAPABILITIES",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff696E7E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (vehicle.loadSmallPackages) _buildChip("Small Loads"),
                        if (vehicle.loadMediumLoads) _buildChip("Medium Loads"),
                        if (vehicle.loadLargeLoads) _buildChip("Large Loads"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- Documents/Photos Section ---
                    if (vehicle.formattedPhotoFrontUrl != null &&
                        vehicle.formattedPhotoFrontUrl!.isNotEmpty) ...[
                      Text(
                        "VEHICLE PHOTOS",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xff696E7E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (vehicle.formattedPhotoFrontUrl != null &&
                                vehicle.formattedPhotoFrontUrl!.isNotEmpty)
                              _buildImagePreview(
                                vehicle.formattedPhotoFrontUrl,
                                "Front",
                              ),
                            if (vehicle.formattedPhotoBackUrl != null &&
                                vehicle.formattedPhotoBackUrl!.isNotEmpty)
                              _buildImagePreview(
                                vehicle.formattedPhotoBackUrl,
                                "Back",
                              ),
                            if (vehicle.formattedPhotoInteriorUrl != null &&
                                vehicle.formattedPhotoInteriorUrl!.isNotEmpty)
                              _buildImagePreview(
                                vehicle.formattedPhotoInteriorUrl,
                                "Interior",
                              ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    const MoreInfoWidget(
                      text: "Changes to vehicle details may require a new verification process.",
                      iconColor: Color(0xff0066FF),
                      textColor: Color(0xff0066FF),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  // Helper to show load types
  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide.none,
    );
  }

  // Helper for image previews
  Widget _buildImagePreview(String? url, String label) {
    if (url == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          color: Colors.black45,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
