import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentUploadField extends StatefulWidget {
  final String? label;          // e.g., "Front of License"
  final String title;           // e.g., "Take a photo"
  final String subtitle;        // e.g., "or tap to upload"
  final IconData icon;          // Custom icon for each type
  final Function(File file) onFilePicked;

  const DocumentUploadField({
    super.key,
    this.label,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onFilePicked,
  });

  @override
  State<DocumentUploadField> createState() => _DocumentUploadFieldState();
}

class _DocumentUploadFieldState extends State<DocumentUploadField> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    // Allows both camera and gallery depending on user choice
    // Usually implemented via a simple bottom sheet
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
      widget.onFilePicked(_selectedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff2D3142),
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: DottedDecoration(
              shape: Shape.box,
              color: const Color(0xffD1D5DB),
              borderRadius: BorderRadius.circular(12),
              strokeWidth: 2,
              dash: const [5, 5],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _selectedFile != null
                  ? Image.file(_selectedFile!, fit: BoxFit.cover)
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xffF4F7FF),
                    child: Icon(widget.icon, color: const Color(0xff0066FF)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5C6A85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9BA3B1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}