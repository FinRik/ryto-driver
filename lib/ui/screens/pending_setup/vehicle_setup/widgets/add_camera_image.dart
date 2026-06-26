import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/helpers/file_picker_util.dart';

class AddVehiclePhoto extends StatefulWidget {
  const AddVehiclePhoto({
    super.key,
    required this.listItem,
    required this.onSelected,
  });

  final String listItem;
  final Function(File) onSelected;

  @override
  State<AddVehiclePhoto> createState() => _AddVehiclePhotoState();
}

class _AddVehiclePhotoState extends State<AddVehiclePhoto> {
  File? _file;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await FilePickerUtil.pickVehiclePhotos(context);

      if (pickedFile != null) {
        setState(() => _file = pickedFile);
        widget.onSelected(_file!);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImage, // Trigger the picker on tap
          child: Container(
            height: 112,
            width: 109,
            decoration: DottedDecoration(
              shape: Shape.box,
              borderRadius: BorderRadius.circular(8),
            ),
            // Show a preview if the file exists, otherwise show the camera icon
            child: _file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_file!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Icon(
                      Icons.linked_camera_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.listItem,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
