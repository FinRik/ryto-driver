import 'dart:io';

/// Checks if a file is within the allowed size limit
///
/// [filePath] - Path to the file
/// [maxSizeMB] - Maximum allowed size in MB (default is 10MB)
/// Returns `true` if file size is within limit, `false` otherwise
Future<bool> isFileSizeValid(String filePath, {double maxSizeMB = 10.0}) async {
  try {
    final file = File(filePath);

    // Check if file exists
    if (!await file.exists()) {
      print("File does not exist: $filePath");
      return false;
    }

    // Get file size in bytes
    final int fileSizeInBytes = await file.length();

    // Format for logging
    final String formattedSize = formatFileSize(fileSizeInBytes);
    print("File size: $formattedSize");

    // Convert to MB for comparison
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > maxSizeMB) {
      print(
        "File size ($formattedSize) exceeds maximum allowed size of ${maxSizeMB}MB",
      );
      // AppResponse.showError("Cannot use image larger than ${maxSizeMB}MB");
      return false;
    } else {
      print("File size is valid ($formattedSize)");
      // AppResponse.showSuccess("Image is ready for upload");
      return true;
    }
  } catch (e) {
    print("Error checking file size: $e");
    return false;
  }
}

String formatFileSize(int bytes) {
  if (bytes <= 0) return "0 B";

  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  int i = 0;
  double size = bytes.toDouble();

  while (size >= 1024 && i < suffixes.length - 1) {
    size /= 1024;
    i++;
  }

  return "${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}";
}

/// Checks the total size of multiple files and validates against a maximum limit
///
/// [filePaths] - List of file paths to check
/// [maxTotalSizeMB] - Maximum allowed total size in MB (default: 20MB)
/// Returns a result containing:
/// - isValid: whether total size is within limit
/// - totalSizeMB: total size in MB
/// - formattedTotalSize: human-readable total size
/// - message: appropriate message for UI
Future<FileSizeResult> checkTotalFilesSize(
  List<String> filePaths, {
  double maxTotalSizeMB = 20.0,
}) async {
  try {
    if (filePaths.isEmpty) {
      return FileSizeResult(
        isValid: true,
        totalSizeMB: 0.0,
        formattedTotalSize: "0 MB",
        message: "No files to check",
      );
    }

    int totalBytes = 0;

    for (String path in filePaths) {
      final file = File(path);

      if (await file.exists()) {
        final size = await file.length();
        totalBytes += size;
      } else {
        print("Warning: File not found - $path");
        // Optionally skip or treat as 0
      }
    }

    final double totalSizeMB = totalBytes / (1024 * 1024);
    final String formattedSize = formatFileSize(totalBytes);

    final bool isValid = totalSizeMB <= maxTotalSizeMB;

    if (isValid) {
      return FileSizeResult(
        isValid: true,
        totalSizeMB: totalSizeMB,
        formattedTotalSize: formattedSize,
        message: "Total size is valid ($formattedSize)",
      );
    } else {
      return FileSizeResult(
        isValid: false,
        totalSizeMB: totalSizeMB,
        formattedTotalSize: formattedSize,
        message:
            "Total files size ($formattedSize) exceeds maximum allowed ${maxTotalSizeMB}MB",
      );
    }
  } catch (e) {
    print("Error checking total files size: $e");
    return FileSizeResult(
      isValid: false,
      totalSizeMB: 0.0,
      formattedTotalSize: "Error",
      message: "Failed to check files size",
    );
  }
}

class FileSizeResult {
  final bool isValid;
  final double totalSizeMB;
  final String formattedTotalSize;
  final String message;

  FileSizeResult({
    required this.isValid,
    required this.totalSizeMB,
    required this.formattedTotalSize,
    required this.message,
  });

  // Helper for easy UI display
  String get errorMessage => isValid ? "" : message;
}

// final result = await checkTotalFilesSize([
// 'path/to/image1.jpg',
// 'path/to/image2.jpg',
// 'path/to/document.pdf',
// ]);
//
// if (result.isValid) {
// print("All good! Total size: ${result.formattedTotalSize}");
// } else {
// AppResponse.showError(result.message);
// }
//
// // Custom limit (e.g., for multiple profile images)
// final result = await checkTotalFilesSize(
// filePaths,
// maxTotalSizeMB: 15.0,   // Allow up to 15MB total
// );
//
// if (!result.isValid) {
// // Show nice message to user
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text(result.message)),
// );
// }
