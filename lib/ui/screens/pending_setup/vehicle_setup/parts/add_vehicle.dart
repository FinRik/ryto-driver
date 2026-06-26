import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/vehicle_setup/vehicle_setup_request.dart';
import '../../../../../core/models/vehicle_setup/vehicle_type_model.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/customs/custom_card_widget.dart';
import '../../../../widgets/inputs/auth_text_field.dart';
import '../../../../widgets/layouts/grid_view_widget.dart';
import '../../../../widgets/more_info_widget.dart';
import '../bloc/vehicle_setup_bloc.dart';
import '../widgets/vehicle_type_list_item.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key, required this.controller});

  final PageController controller;

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _formKey = GlobalKey<FormState>();
  final _makeModelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();

  VehicleTypeModel? _selectedVehicleType;

  @override
  void dispose() {
    _makeModelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submitDetails() {
    if (_selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a Vehicle Type to continue"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final year = int.parse(_yearController.text.trim());
      context.read<VehicleSetupBloc>().add(
        AddVehicleDetailsRequested(
          VehicleDetailsRequest(
            type: _selectedVehicleType!.id,
            makeModel: _makeModelController.text.trim(),
            year: year,
            color: _colorController.text.trim(),
            plateNumber: _plateController.text.trim(),
          ),
        ),
      );
    }
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
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomCardWidget(
                  title: "Vehicle Type".toUpperCase(),
                  disableBorder: true,
                  padding: EdgeInsets.zero,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff696E7E),
                  ),
                  child: GridViewWidget(
                    crossAxisCount: 3,
                    childAspectRatio: .85,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 16,
                    list: VehicleTypeModel.packageSizes,
                    physics: const NeverScrollableScrollPhysics(),
                    builder: (int index, listItem, bool isSelected) {
                      return VehicleTypeListItem(
                        isItemSelected: isSelected,
                        listItem: listItem!,
                      );
                    },
                    onSelected: (selectedItem) {
                      setState(() => _selectedVehicleType = selectedItem);
                    },
                  ),
                ),
                CustomCardWidget(
                  title: "Vehicle Information".toUpperCase(),
                  disableBorder: true,
                  padding: EdgeInsets.zero,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff696E7E),
                  ),
                  child: Column(
                    children: [
                      AuthTextField(
                        label: "Vehicle Make & Model",
                        controller: _makeModelController,
                        textInputType: TextInputType.text,
                        hint: "E,g Toyota Camry",
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter vehicle make and model"
                            : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AuthTextField(
                              label: "Year",
                              controller: _yearController,
                              textInputType: TextInputType.number,
                              hint: "2022",
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Required";
                                if (value.length != 4) return "Invalid year";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: AuthTextField(
                              label: "Color",
                              controller: _colorController,
                              textInputType: TextInputType.text,
                              hint: "Silver",
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? "Required"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      AuthTextField(
                        label: "Plate Number",
                        controller: _plateController,
                        textInputType: TextInputType.text,
                        hint: "E.g ABC 123 XY",
                        bottomMargin: 9,
                        validator: (value) => (value == null || value.isEmpty)
                            ? "Enter plate number"
                            : null,
                      ),
                      const Text(
                        "Make sure this matches the vehicle you'll be using for trips.",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const MoreInfoWidget(
                  text:
                      'Provide accurate vehicle details to ensure passenger safety and trust. You may be asked to upload photos in the next steps.',
                  iconColor: Color(0xff0066FF),
                  textColor: Color(0xff0066FF),
                ),
                const SizedBox(height: 120),
                BottomAppBar(
                  elevation: 3,
                  color: Colors.white,
                  height: 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        text: "Continue to capacity",
                        isBusy: state.status == VehicleStatus.loading,
                        onTap: _submitDetails,
                        showSuffixIcon: false,
                        suffixIcon: Icons.keyboard_arrow_right_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
