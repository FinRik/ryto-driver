import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/texts/header_text.dart';
import 'bloc/trip_setup_bloc.dart';

class SetTripCapacityScreen extends StatefulWidget {
  const SetTripCapacityScreen({super.key});

  @override
  State<SetTripCapacityScreen> createState() => _ConfigureCapacityScreenState();
}

class _ConfigureCapacityScreenState extends State<SetTripCapacityScreen> {
  // Local state for UI responsiveness
  late int availableSeats;
  late bool smallSelected;
  late bool mediumSelected;
  late bool largeSelected;

  @override
  void initState() {
    super.initState();
    // Initialize from existing Bloc state if user navigated back
    final draft = context.read<TripSetupBloc>().state.draft;
    availableSeats = draft.passengerSeats > 0 ? draft.passengerSeats : 3;

    // If you want to persist the exact checkboxes, you'd need more fields in the Request
    // class. For now, we'll default them based on the packagesAllowed bool.
    smallSelected = draft.packagesAllowed;
    mediumSelected = draft.packagesAllowed;
    largeSelected = draft.packagesAllowed;
  }

  void _updateCapacityInBloc() {
    final bloc = context.read<TripSetupBloc>();

    // Logic: If any package size is selected, packagesAllowed is true
    bool anyPackageAllowed = smallSelected || mediumSelected || largeSelected;

    final newDraft = bloc.state.draft.copyWith(
      passengerSeats: availableSeats,
      packagesAllowed: anyPackageAllowed,
    );

    bloc.add(UpdateTripDraft(newDraft));
  }

  //   @override
  //   Widget build(BuildContext context) {
  //     return BaseScaffoldWidget(
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const HeaderText(
  //                     label: "Configure Trip Capacity",
  //                     subText:
  //                         "Confirm the space available for this specific ride.",
  //                     padding: EdgeInsets.zero,
  //                   ),
  //                   const SizedBox(height: 24),
  //
  //                   // 1. Passengers Section
  //                   _buildPassengerCounter(),
  //
  //                   const SizedBox(height: 24),
  //
  //                   // 2. Packages Section
  //                   _buildPackageSelector(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //           // 3. Primary Action Button
  //           Button(
  //             onTap: () => router.push(Paths.SETMETTINGPOINT),
  //             text: "Set Pricing",
  //             showSuffixIcon: true,
  //             suffixIcon: Icons.chevron_right,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget _buildPassengerCounter() {
  //     return Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF8F9FB),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               _buildIconCircle(Icons.group_outlined, Colors.blue),
  //               const SizedBox(width: 12),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: const [
  //                   Text(
  //                     "Passengers",
  //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //                   ),
  //                   Text(
  //                     "Seats available for this trip",
  //                     style: TextStyle(color: Colors.grey, fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 "Available Seats",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //               ),
  //               Row(
  //                 children: [
  //                   _buildCounterButton(Icons.remove, () {
  //                     if (availableSeats > 1) setState(() => availableSeats--);
  //                   }),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 20),
  //                     child: Text(
  //                       "$availableSeats",
  //                       style: const TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   _buildCounterButton(Icons.add, () {
  //                     setState(() => availableSeats++);
  //                   }, isPrimary: true),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget _buildPackageSelector() {
  //     return Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: const Color(0xFFF0F2F5)),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               _buildIconCircle(Icons.inventory_2_outlined, Colors.blue),
  //               const SizedBox(width: 12),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: const [
  //                   Text(
  //                     "Packages",
  //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //                   ),
  //                   Text(
  //                     "What parcel sizes can you carry?",
  //                     style: TextStyle(color: Colors.grey, fontSize: 12),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           _buildPackageTile(
  //             icon: Icons.mail_outline,
  //             title: "Small",
  //             subtitle: "Envelopes, small boxes",
  //             isSelected: smallSelected,
  //             onChanged: (v) => setState(() => smallSelected = v!),
  //           ),
  //           _buildPackageTile(
  //             icon: Icons.inventory_2_outlined,
  //             title: "Medium",
  //             subtitle: "Backpacks, carry-ons",
  //             isSelected: mediumSelected,
  //             onChanged: (v) => setState(() => mediumSelected = v!),
  //           ),
  //           _buildPackageTile(
  //             icon: Icons.delete_outline,
  //             title: "Large",
  //             subtitle: "Suitcases, large crates",
  //             isSelected: largeSelected,
  //             onChanged: (v) => setState(() => largeSelected = v!),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripSetupBloc, TripSetupState>(
      builder: (context, state) {
        return BaseScaffoldWidget(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(
                        label: "Configure Trip Capacity",
                        subText:
                            "Confirm the space available for this specific ride.",
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),

                      // 1. Passengers Section
                      _buildPassengerCounter(),

                      const SizedBox(height: 24),

                      // 2. Packages Section
                      _buildPackageSelector(),
                    ],
                  ),
                ),
              ),

              // 3. Primary Action Button
              Button(
                onTap: () {
                  _updateCapacityInBloc();
                  router.push(Paths.SETMETTINGPOINT);
                },
                text: "Set Pricing",
                showSuffixIcon: true,
                suffixIcon: Icons.chevron_right,
              ),
            ],
          ),
        );
      },
    );
  }

  // Updated Counter Logic with Bloc sync
  Widget _buildPassengerCounter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // ... same headers ...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Available Seats",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  _buildCounterButton(Icons.remove, () {
                    if (availableSeats > 1) {
                      setState(() => availableSeats--);
                      _updateCapacityInBloc();
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$availableSeats",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCounterButton(Icons.add, () {
                    setState(() => availableSeats++);
                    _updateCapacityInBloc();
                  }, isPrimary: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Updated Checkbox Logic with Bloc sync
  Widget _buildPackageSelector() {
    return Container(
      // ... same decoration ...
      child: Column(
        children: [
          // ... same headers ...
          _buildPackageTile(
            icon: Icons.mail_outline,
            title: "Small",
            subtitle: "Envelopes, small boxes",
            isSelected: smallSelected,
            onChanged: (v) {
              setState(() => smallSelected = v!);
              _updateCapacityInBloc();
            },
          ),
          _buildPackageTile(
            icon: Icons.inventory_2_outlined,
            title: "Medium",
            subtitle: "Backpacks, carry-ons",
            isSelected: mediumSelected,
            onChanged: (v) {
              setState(() => mediumSelected = v!);
              _updateCapacityInBloc();
            },
          ),
          _buildPackageTile(
            icon: Icons.delete_outline,
            title: "Large",
            subtitle: "Suitcases, large crates",
            isSelected: largeSelected,
            onChanged: (v) {
              setState(() => largeSelected = v!);
              _updateCapacityInBloc();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPackageTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.grey),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: onChanged,
        activeColor: const Color(0xFF0061FF),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildCounterButton(
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF0061FF) : Colors.white,
          shape: BoxShape.circle,
          border: isPrimary ? null : Border.all(color: const Color(0xFF0061FF)),
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF0061FF),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
