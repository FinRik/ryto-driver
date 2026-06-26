import 'dart:io';
import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final Object? originalError;

  NetworkException(this.message, {this.originalError});

  /// Factory constructor to convert generic system or library exceptions
  /// into formatted user-friendly network exceptions.
  factory NetworkException.fromError(Object error) {
    // 1. Handle complete local offline state
    if (error is SocketException) {
      return NetworkException(
        "No internet connection. Please check your network and try again.",
        originalError: error,
      );
    }

    // 2. Handle network client exceptions (Dio configuration states)
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return NetworkException(
            "Connection timed out. The server is taking too long to respond.",
            originalError: error,
          );
        case DioExceptionType.connectionError:
          return NetworkException(
            "Unable to reach the server. Please verify your connection.",
            originalError: error,
          );
        case DioExceptionType.badResponse:
        // Try parsing backend validation messages if your server returns them
          final serverMessage = error.response?.data?['message'];
          return NetworkException(
            serverMessage ?? "Server error occurred (${error.response?.statusCode}).",
            originalError: error,
          );
        default:
          return NetworkException(
            "A network communication error occurred.",
            originalError: error,
          );
      }
    }

    // 3. Fallback for unexpected or generic errors
    return NetworkException(
      error.toString(),
      originalError: error,
    );
  }

  @override
  String toString() => message;
}