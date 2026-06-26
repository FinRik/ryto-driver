import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/action_status.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../utils/helpers/file_picker_util.dart';
import '../../../../../utils/helpers/file_size_checker.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/layouts/scrollable_horizontal_list.dart';
import '../../../../widgets/texts/header_text.dart';
import '../../../../widgets/more_info_widget.dart';
import '../../../home/bloc/home_bloc.dart';
import '../bloc/vehicle_setup_bloc.dart';
import '../widgets/add_camera_image.dart';
import '../widgets/file_upload_tile.dart';

class AddVehicleDocs extends StatefulWidget {
  const AddVehicleDocs({super.key, required this.controller});

  final PageController controller;

  @override
  State<AddVehicleDocs> createState() => _AddVehicleDocsState();
}

class _AddVehicleDocsState extends State<AddVehicleDocs> {
  // 1. Files for Documents
  File? _licenseFile;
  File? _roadworthinessFile;
  File? _insuranceFile;

  // 2. Files for Vehicle Photos
  File? _photoFront;
  File? _photoBack;
  File? _photoSide;
  File? _photoInterior;
  File? _photoOther;

  // Helper to calculate progress for the 3 main docs
  int get _uploadedCount {
    int count = 0;
    if (_licenseFile != null) count++;
    if (_roadworthinessFile != null) count++;
    if (_insuranceFile != null) count++;
    return count;
  }

  // 3. Document Picker Logic (using image_picker or similar)
  Future<void> _pickDocument(String type) async {
    // Assuming you have a utility to pick files/images
    final file = await FilePickerUtil.pickVehicleDocs();
    if (file == null) return;

    setState(() {
      switch (type) {
        case 'license':
          _licenseFile = file;
          break;
        case 'road':
          _roadworthinessFile = file;
          break;
        case 'insurance':
          _insuranceFile = file;
          break;
      }
    });
  }

  Future<void> _submitDocuments() async {
    // 4. Validation
    if (_licenseFile == null ||
        _roadworthinessFile == null ||
        _insuranceFile == null) {
      _showWarning("Please upload all three official documents.");
      return;
    }
    if (_photoFront == null ||
        _photoBack == null ||
        _photoSide == null ||
        _photoInterior == null) {
      _showWarning("Please provide all required vehicle photos.");
      return;
    }

    final result = await checkTotalFilesSize([
      _licenseFile!.path,
      _roadworthinessFile!.path,
      _insuranceFile!.path,
      _photoFront!.path,
      _photoBack!.path,
      _photoSide!.path,
      _photoInterior!.path,
      _photoOther!.path,
    ]);

    if (result.isValid) {
      print("All good! Total size: ${result.formattedTotalSize}");
    } else {
      // AppResponse.showError(result.message);
    }

    // 5. Dispatch Event
    context.read<VehicleSetupBloc>().add(
      AddVehicleDocumentsRequested(
        license: _licenseFile!,
        roadworthiness: _roadworthinessFile!,
        insurance: _insuranceFile!,
        photoFront: _photoFront!,
        photoBack: _photoBack!,
        photoSide: _photoSide!,
        photoInterior: _photoInterior!,
        photoOther: _photoOther ?? _photoFront!,
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
          context.read<HomeBloc>().add(
            UpdateOnboardingState(
              status: ActionStatus.pending,
              type: OnboardingStep.vehicle,
            ),
          );
          router.go(Paths.HOME);
        }
        // if (state is VehicleFailure) {
        //   _showError(state.error);
        // }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const MoreInfoWidget(
                text: "Upload Nigerian Specifics",
                subWidget: Text(
                  "Please provide clear photos of your official vehicle documents to verify your Ryto driver account.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 32),

              // Official Documents List
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FileUploadTile(
                    leadingIcon: Icons.description_outlined,
                    title: "Vehicle License",
                    subtitle: _licenseFile != null
                        ? "Uploaded"
                        : "Not uploaded",
                    status: _licenseFile != null
                        ? UploadStatus.pending
                        : UploadStatus.none,
                    isUploaded: _licenseFile != null,
                    onUpload: () => _pickDocument('license'),
                  ),
                  const SizedBox(height: 16),
                  FileUploadTile(
                    leadingIcon: Icons.verified_user_outlined,
                    title: "Roadworthiness",
                    subtitle: _roadworthinessFile != null
                        ? "Uploaded"
                        : "Not uploaded",
                    status: _roadworthinessFile != null
                        ? UploadStatus.pending
                        : UploadStatus.none,
                    isUploaded: _roadworthinessFile != null,
                    onUpload: () => _pickDocument('road'),
                  ),
                  const SizedBox(height: 16),
                  FileUploadTile(
                    leadingIcon: Icons.verified_user_outlined,
                    title: "Insurance",
                    subtitle: _insuranceFile != null
                        ? "Uploaded"
                        : "Not uploaded",
                    status: _insuranceFile != null
                        ? UploadStatus.pending
                        : UploadStatus.none,
                    isUploaded: _insuranceFile != null,
                    onUpload: () => _pickDocument('insurance'),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              // Updated Progress Bar based on local state
              UploadProgressBar(total: 3, uploaded: _uploadedCount),

              const SizedBox(height: 48),
              const HeaderText(
                label: "Upload Vehicle Photos",
                subText:
                    "Provide clear photos of your vehicle for safety and quality standards.",
              ),
              const SizedBox(height: 32),

              // Vehicle Image Grid
              ScrollableHorizontalList(
                list: const [
                  "Front of car",
                  "Back of car",
                  "Side",
                  "Interior (Seats)",
                  "Other",
                ],
                onSelected: (val) {},
                builder: (index, listItem, isSelected, falseItem) {
                  return AddVehiclePhoto(
                    listItem: listItem!,
                    onSelected: (file) {
                      setState(() {
                        if (listItem == "Front of car") _photoFront = file;
                        if (listItem == "Back of car") _photoBack = file;
                        if (listItem == "Side") _photoSide = file;
                        if (listItem == "Interior (Seats)")
                          _photoInterior = file;
                        if (listItem == "Other") _photoOther = file;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 178),
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
                      text: "Upload & Continue",
                      isBusy: state.status == VehicleStatus.loading,
                      onTap: _submitDocuments,
                      showSuffixIcon: false,
                      suffixIcon: Icons.keyboard_arrow_right_outlined,
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
