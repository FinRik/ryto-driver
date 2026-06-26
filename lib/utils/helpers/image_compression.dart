import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressionHelper {

  // Compress the image to a target size in MB
  static Future<XFile?> compressImage(File file, {required int targetSizeInMB}) async {
    int targetSizeInBytes = targetSizeInMB * 1024 * 1024;
    int quality = 100; // Start with highest quality
    int minWidth = 1920; // Starting resize width, adjust as needed

    XFile? compressedFile;
    int fileSizeInBytes = await file.length();

    while (fileSizeInBytes > targetSizeInBytes && quality > 10) {
      // Compress the image
      compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.absolute.path}_compressed.jpg',
        quality: quality,
        minWidth: minWidth,
      );

      if (compressedFile == null) {
        return XFile(file.path); // Return original if compression failed
      }

      fileSizeInBytes = await compressedFile.length();

      // Adjust quality and size progressively
      quality -= 10; // Reduce quality by 10% each iteration
      minWidth = (minWidth * 0.9).toInt(); // Reduce width by 10% each iteration
    }

    return compressedFile ?? XFile(file.path); // Return the final compressed file
  }

// // 2. compress file and get file.
//   Future<File?> _compressAndGetFile(File file, Im.Image image) async {
//     final tempDir = await getTemporaryDirectory();
//     final rand = Math.Random().nextInt(10000);
//
//     final path = tempDir.path;
//     String targetPath = '$path/img_$rand.jpg';
//
//     double originRatio = image.width / image.height;
//
//     File? result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       targetPath,
//       quality: 70,
//       minHeight: originRatio > 1 ? 1080 : 1920,
//       minWidth: originRatio > 1 ? 1080 : 1920,
//     );
//
// //   print(file.lengthSync());
// //   print(result.lengthSync());
//
//     return result;
//   }
}
