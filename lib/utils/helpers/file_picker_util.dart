import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'file_size_checker.dart';
import 'image_compression.dart';

class FilePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Picks multiple images and returns List<File>
  static Future<List<File>> pickMultipleImages({
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
    int maxImages = 10, // you can limit if needed
    BuildContext? context,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      // Convert XFile to File
      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick images: ${e.toString()}')),
        );
      } else {
        debugPrint('ImagePicker Error: $e');
      }
      return [];
    }
  }

  /// Quick helpers for common use cases
  static Future<File?> pickFromGallery({
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context,
  }) async {
    return _pickImage(
      isCamera: true,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      context: context,
    );
  }

  static Future<File?> pickFromCamera({
    int imageQuality = 90,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context,
  }) async {
    return _pickImage(
      isCamera: true,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      context: context,
    );
  }

  static Future<File?> pickVehicleDocs() async {
    final result = await _pickImage(isCamera: false);

    if (result != null && await isFileSizeValid(result.path)) {
      File imageFile = File(result.path);
      final appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final fileName = path.basename(imageFile.path);
      final File localImage = await imageFile.copy('$appDocPath/$fileName');
      int fileSizeInBytes = await localImage.length();

      print("Before File Compression:${formatFileSize(fileSizeInBytes)}");

      // If the image is larger than 5MB, compress it
      // if (fileSizeInBytes > 5 * 1024 * 1024) {
      final resDes = await ImageCompressionHelper.compressImage(
        localImage,
        targetSizeInMB: 5,
      );

      int? afterFileSizeInBytes = await resDes?.length();

      print("After File Compression:${formatFileSize(afterFileSizeInBytes!)}");
      return File(resDes!.path);
    } else {
      // AppResponse.showError("Image selection was canceled");
      print("Image selection was canceled");
      return null;
    }
  }

  static Future<File?> pickVehiclePhotos(BuildContext context) async {
    final result = await _pickImage(isCamera: false, context: context);

    if (result != null && await isFileSizeValid(result.path,)) {
      File imageFile = File(result.path);
      final appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final fileName = path.basename(imageFile.path);
      final File localImage = await imageFile.copy('$appDocPath/$fileName');
      int fileSizeInBytes = await localImage.length();

      print("Before File Compression:${formatFileSize(fileSizeInBytes)}");

      // If the image is larger than 5MB, compress it
      // if (fileSizeInBytes > 5 * 1024 * 1024) {
      final resDes = await ImageCompressionHelper.compressImage(
        localImage,
        targetSizeInMB: 2,
      );

      int? afterFileSizeInBytes = await resDes?.length();

      print("After File Compression:${formatFileSize(afterFileSizeInBytes!)}");
      return File(resDes!.path);
    } else {
      // AppResponse.showError("Image selection was canceled");
      print("Image selection was canceled");
      return null;
    }
  }

  /// Picks a single image and returns File?
  static Future<File?> _pickImage({
    required bool isCamera,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
    BuildContext? context, // optional for showing errors
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      } else {
        debugPrint('ImagePicker Error: $e');
      }
      return null;
    }
  }
}
