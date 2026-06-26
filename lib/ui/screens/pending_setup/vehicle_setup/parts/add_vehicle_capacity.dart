import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/res/images.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../../core/models/vehicle_setup/vehicle_setup_request.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/customs/custom_action_tile.dart';
import '../../../../widgets/customs/custom_card_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/more_info_widget.dart';
import '../../../../widgets/texts/header_text.dart';
import '../bloc/vehicle_setup_bloc.dart';
import '../widgets/seat_selector_widget.dart';
import '../widgets/selection_card.dart';
import '../widgets/storage_item.dart';

class AddVehicleCapacity extends StatefulWidget {
  const AddVehicleCapacity({super.key, required this.controller});

  final PageController controller;

  @override
  State<AddVehicleCapacity> createState() => _AddVehicleCapacityState();
}

class _AddVehicleCapacityState extends State<AddVehicleCapacity> {
  // 1. Individual Boolean Flags for Load Types
  int _seatCount = 0;
  bool _frontSeatAvailable = false;
  bool _loadSmallPackages = false;
  bool _loadMediumLoads = false;
  bool _loadLargeLoads = false;
  String? _storageLocation;

  void _submitCapacity() {
    // 2. Comprehensive Validation
    if (_seatCount <= 0) {
      _showWarning("Please select the number of available seats.");
      return;
    }

    // Ensure at least one load type is selected
    if (!_loadSmallPackages && !_loadMediumLoads && !_loadLargeLoads) {
      _showWarning("Please select at least one type of load you can carry.");
      return;
    }

    if (_storageLocation == null || _storageLocation!.isEmpty) {
      _showWarning("Please select a storage location.");
      return;
    }

    // 3. Dispatch Event with the specific boolean structure
    context.read<VehicleSetupBloc>().add(
      AddVehicleCapacityRequested(
        VehicleCapacityRequest(
          passengerSeats: _seatCount,
          frontSeatAvailable: _frontSeatAvailable,
          loadSmallPackages: _loadSmallPackages,
          loadMediumLoads: _loadMediumLoads,
          loadLargeLoads: _loadLargeLoads,
          storageLocation: _storageLocation!,
        ),
      ),
    );
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleSetupBloc, VehicleSetupState>(
      listener: (context, state) {
        if (state.status == VehicleStatus.success) {
          widget.controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const HeaderText(
                label: "Set your Capacity",
                subText:
                    "Let us know how many passengers you can accommodate for intercity trips",
              ),
              const SizedBox(height: 24),

              // Seat Selector
              CustomCardWidget(
                title: "How many passenger seats available?",
                child: SeatSelectorWidget(
                  onChanged: (value) => setState(() => _seatCount = value),
                ),
              ),

              // Front Seat Toggle
              CustomActionTile(
                leadingIcon: SvgWidget(
                  assetName: AppSvgs.musicFilled,
                  height: 40,
                  width: 40,
                ),
                title: "Front Seat Available",
                subtitle: const Text("Allow passengers in front"),
                trailing: Transform.scale(
                  scale: .8,
                  child: Switch(
                    value: _frontSeatAvailable,
                    onChanged: (val) =>
                        setState(() => _frontSeatAvailable = val),
                  ),
                ),
              ),
              SizedBox(height: 24),
              MoreInfoWidget(
                text:
                    "Higher capacity allows you to earn more per trip management, but ensure all seats meet Ryto's safety standards.",
                iconColor: Color(0xff0066FF),
                textColor: Color(0xff0066FF),
              ),
              SizedBox(height: 64),
              // Load Types - Integrated with boolean flags
              CustomCardWidget(
                title: "Available Load Types",
                child: Column(
                  children: [
                    SelectionCard(
                      title: "Small packages only",
                      description:
                          "Envelopes, padded mailers, and small shoe boxes",
                      image: Image.asset(
                        AppImages.smallPackages,
                        fit: BoxFit.cover,
                      ),
                      isSelected: _loadSmallPackages,
                      onTap: () => setState(
                        () => _loadSmallPackages = !_loadSmallPackages,
                      ),
                      icon: const Icon(Icons.mail_outline, color: Colors.blue),
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: "Medium loads",
                      description:
                          "Standard suitcases, large boxes, and bulk groceries",
                      icon: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.blue,
                      ),
                      image: Image.asset(
                        AppImages.mediumPackages,
                        fit: BoxFit.cover,
                      ),
                      isSelected: _loadMediumLoads,
                      onTap: () =>
                          setState(() => _loadMediumLoads = !_loadMediumLoads),
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: "Large loads",
                      description:
                          "Furniture, multiple large boxes, or heavy equipment",
                      icon: const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.blue,
                      ),
                      image: Image.asset(
                        AppImages.largePackages,
                        fit: BoxFit.cover,
                      ),
                      isSelected: _loadLargeLoads,
                      onTap: () =>
                          setState(() => _loadLargeLoads = !_loadLargeLoads),
                    ),
                  ],
                ),
              ),

              // Storage Location
              CustomCardWidget(
                title: "Storage Location",
                child: StorageItemWidget(
                  onSelected: (item, id) =>
                      setState(() => _storageLocation = id),
                ),
              ),

              const SizedBox(height: 120),

              BottomAppBar(
                elevation: 3,
                color: Colors.white,
                height: 170,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You can update these profile at any time in your profile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff94A3B8),
                      ),
                    ),
                    SizedBox(height: 20),
                    Button(
                      text: "Save Capacity",
                      isBusy: state.status == VehicleStatus.loading,
                      onTap: _submitCapacity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
