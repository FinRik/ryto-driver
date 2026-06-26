import 'package:dio/dio.dart';
import 'dart:convert';

class CustomDioException extends DioException {
  CustomDioException({
    required super.requestOptions,
    super.response,
    super.type,
    dynamic super.error,
  });

  String get responseMessage => response?.data['message'];

  @override
  String get message {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';

      case DioExceptionType.connectionError:
        return 'No internet connection';

      case DioExceptionType.badResponse:
        return _handleStatusCode(response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request cancelled';

      case DioExceptionType.unknown:
        if (error != null && error.toString().contains('SocketException')) {
          return 'No internet connection';
        }
        return 'An unexpected error occurred';

      default:
        return 'An unexpected error occurred';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error occurred';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Error: ${statusCode ?? "Unknown status code"}';
    }
  }

  // Get server error message if available
  String? get serverMessage {
    if (response?.data == null) return null;

    try {
      // Handle string response
      if (response!.data is String) {
        try {
          final parsed = json.decode(response!.data);
          return _extractMessage(parsed);
        } catch (_) {
          return response!.data;
        }
      }

      // Handle map response
      if (response!.data is Map) {
        return _extractMessage(response!.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // Extract message from common API response formats
  String? _extractMessage(Map<dynamic, dynamic> data) {
    // Common response formats
    final possibleKeys = [
      'message',
      'error',
      'error_message',
      'error_description',
      'errorMessage',
      'errors',
    ];

    for (final key in possibleKeys) {
      if (data.containsKey(key)) {
        final value = data[key];
        if (value is String) return value;
        if (value is List) return value.join(', ');
        if (value is Map) return value.values.join(', ');
      }
    }

    // If no standard keys found, try to get the first string value
    final firstStringValue =
        data.values.whereType<String>().cast<String?>().firstOrNull;

    return firstStringValue;
  }

  // Get full error details including validation errors
  Map<String, dynamic>? get serverErrors {
    if (response?.data == null) return null;

    try {
      if (response!.data is String) {
        return json.decode(response!.data);
      }

      if (response!.data is Map) {
        return Map<String, dynamic>.from(response!.data);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // Factory constructor to create CustomDioException from DioException
  factory CustomDioException.fromDioException(DioException dioError) {
    return CustomDioException(
      requestOptions: dioError.requestOptions,
      response: dioError.response,
      type: dioError.type,
      error: dioError.error,
    );
  }

  @override
  String toString() => "DioException: $message (Status code: $type)";
}

class ExceptionNotACustomer implements Exception {
  final String message = "Access denied. Only customer accounts can log in here.";
}

class ExceptionInvalidCredentials implements Exception {
  final String message = "Invalid phone number or verification code.";
}

class ExceptionUnverifiedAccount implements Exception {
  final String message = "Your account has not been verified.";
}

class LocationServiceDisabledException implements Exception{
  final String message = 'Location services are disabled';
}

class LocationPermissionDeniedException implements Exception{
  final String message = 'Location permissions are denied';
}

class LocationPermissionPermanentlyDeniedException implements Exception{
  final String message = 'Location permissions are permanently denied';
}

class LocationTimeoutException implements Exception{
  final String message = 'Location request timed out';
}