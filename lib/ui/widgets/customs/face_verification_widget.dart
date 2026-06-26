// import 'dart:io';
// import 'package:dotted_decoration/dotted_decoration.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// enum FaceStatus { none, processing, faceDetected, noFaceDetected, error }
//
// class FaceVerificationWidget extends StatefulWidget {
//   final Function(File? file, FaceStatus status) onChange;
//   final bool isImagePicker;
//
//   const FaceVerificationWidget({
//     super.key,
//     required this.onChange,
//     this.isImagePicker = true,
//   });
//
//   @override
//   State<FaceVerificationWidget> createState() => _FaceVerificationWidgetState();
// }
//
// class _FaceVerificationWidgetState extends State<FaceVerificationWidget> {
//   File? _image;
//   FaceStatus _status = FaceStatus.none;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableTracking: true,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _status = FaceStatus.processing;
//       });
//       widget.onChange(_image, _status);
//     }
//   }
//
//   Future<void> _captureImage() async {
//     final picker = ImagePicker();
//     // In a real app, you'd show a bottom sheet to choose Camera vs Gallery
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.camera,
//       preferredCameraDevice: CameraDevice.front,
//     );
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _status = FaceStatus.processing;
//       });
//       widget.onChange(_image, _status);
//
//       _detectFace(_image!);
//     }
//   }
//
//   Future<void> _detectFace(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     try {
//       final faces = await _faceDetector.processImage(inputImage);
//
//       setState(() {
//         _status = faces.isNotEmpty
//             ? FaceStatus.faceDetected
//             : FaceStatus.noFaceDetected;
//       });
//       widget.onChange(_image, _status);
//     } catch (e) {
//       setState(() => _status = FaceStatus.error);
//       widget.onChange(_image, _status);
//     }
//   }
//
//   @override
//   void dispose() {
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           // Main Circle Container
//           Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: _getStatusColor(),
//                 width: 4,
//                 style: BorderStyle.solid,
//               ),
//               image: _image != null
//                   ? DecorationImage(
//                       image: FileImage(_image!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: _image == null
//                 ? const Icon(Icons.person, size: 100, color: Colors.grey)
//                 : (_status == FaceStatus.processing
//                       ? const CircularProgressIndicator()
//                       : null),
//           ),
//           // Action Button
//           GestureDetector(
//             onTap: widget.isImagePicker ? _pickImage : _captureImage,
//             child: Container(
//               height: 40,
//               width: 40,
//               padding: EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Color(0xffE3FB20),
//                 shape: BoxShape.circle,
//               ),
//               child: CircleAvatar(
//                 backgroundColor: Color(0xff0066FF),
//                 radius: 20,
//                 child: const Icon(Icons.camera_alt, color: Colors.white, size: 18,),
//               ),
//             ),
//           ),
//           // Status Label (Optional "Live Preview" style)
//           if (_status == FaceStatus.faceDetected)
//             Positioned(
//               top: 140,
//               left: 50,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: DottedDecoration(
//                   color: Colors.greenAccent,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "FACE VERIFIED",
//                   style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor() {
//     switch (_status) {
//       case FaceStatus.faceDetected:
//         return Colors.blue;
//       case FaceStatus.noFaceDetected:
//         return Colors.red;
//       case FaceStatus.processing:
//         return Colors.yellow;
//       default:
//         return Colors.grey.shade300;
//     }
//   }
// }

import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../app/res/icons.dart';
import 'svg_widget.dart';

enum FaceStatus {
  none,
  processing,
  faceDetected,
  noFaceDetected,
  verifiedNotRequired,
  error,
}

class FaceVerificationWidget extends StatefulWidget {
  final Function(File? file, FaceStatus status) onChange;
  // True = Gallery (No Verification), False = Camera (Verification)
  final bool isImagePicker, isBusy;

  const FaceVerificationWidget({
    super.key,
    required this.onChange,
    this.isImagePicker = true,
    this.isBusy = false,
  });

  @override
  State<FaceVerificationWidget> createState() => _FaceVerificationWidgetState();
}

class _FaceVerificationWidgetState extends State<FaceVerificationWidget> {
  File? _image;
  FaceStatus _status = FaceStatus.none;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  );

  Future<void> _handleAction() async {
    final picker = ImagePicker();
    final source = widget.isImagePicker
        ? ImageSource.gallery
        : ImageSource.camera;

    final pickedFile = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (widget.isImagePicker) {
        // --- Gallery Flow: No Verification Required ---
        setState(() {
          _image = file;
          _status = FaceStatus.verifiedNotRequired;
        });
        widget.onChange(_image, _status);
      } else {
        // --- Camera Flow: Run Face Detection ---
        setState(() {
          _image = file;
          _status = FaceStatus.processing;
        });
        widget.onChange(_image, _status);
        await _detectFace(file);
      }
    }
  }

  Future<void> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    try {
      final faces = await _faceDetector.processImage(inputImage);
      setState(() {
        _status = faces.isNotEmpty
            ? FaceStatus.faceDetected
            : FaceStatus.noFaceDetected;
      });
      widget.onChange(_image, _status);
    } catch (e) {
      setState(() => _status = FaceStatus.error);
      widget.onChange(_image, _status);
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Circle
          Container(
            width: widget.isImagePicker ? 120 : 200,
            height: widget.isImagePicker ? 120 : 200,
            decoration: _image == null
                ? DottedDecoration(
                    shape: Shape.circle,
                    color: Colors.grey.shade400,
                    strokeWidth: 2,
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _getBorderColor(), width: 3),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
            child: widget.isBusy
                ? Center(
                    child: Transform.scale(
                      scale: .6,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  )
                : _image == null
                ? Center(
                    child: SvgWidget(
                      assetName: widget.isImagePicker
                          ? AppIcons.person
                          : AppIcons.face,
                      height: widget.isImagePicker ? 24 : 49,
                      width: widget.isImagePicker ? 24 : 49,
                    ),
                  )
                : (_status == FaceStatus.processing
                      ? const Center(child: CircularProgressIndicator())
                      : null),
          ),

          // "LIVE PREVIEW" or "VERIFIED" Badge
          // Only show for Camera mode OR if a face was actually detected
          if (!widget.isImagePicker || _status == FaceStatus.faceDetected)
            Positioned(
              bottom: 45,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _status == FaceStatus.faceDetected
                      ? Colors.greenAccent
                      : const Color(0xffE3FB20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _status == FaceStatus.faceDetected
                      ? "FACE VERIFIED"
                      : "LIVE PREVIEW",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

          // Action Button
          Positioned(
            bottom: widget.isImagePicker ? 0 : 5,
            right: widget.isImagePicker ? 0 : 15,
            child: GestureDetector(
              onTap: _handleAction,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xff0066FF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isImagePicker
                        ? Color(0xffE3FB20)
                        : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: Icon(
                  widget.isImagePicker
                      ? Icons.camera_alt
                      : Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor() {
    if (widget.isImagePicker) return Colors.grey.shade300;
    switch (_status) {
      case FaceStatus.faceDetected:
        return Colors.blue;
      case FaceStatus.noFaceDetected:
        return Colors.red;
      case FaceStatus.processing:
        return Colors.orange;
      default:
        return const Color(0xff0066FF); // Default Blue for Live Mode
    }
  }
}
