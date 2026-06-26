import 'dart:convert';
import 'dart:io';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../ui/dialogs/error_dialog.dart';
import '../../utils/logger/logger.dart';
import '../../utils/storage/token_storage.dart';
import '../models/api_error_response.dart';
import '../routes/router.dart';
import '../routes/routes.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;
  static bool _isDialogShowing = false;

  ErrorInterceptor(this.dio);

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    if (statusCode >= 200 && statusCode < 300) {
      return handler.next(response);
    }

    // Extract message once, reuse everywhere
    final String message = _extractMessage(data, statusCode);

    if (statusCode == 422) {
      // Show the formatted field errors (not just the top-level message)
      final String displayMessage = _extract422Errors(data) ?? message;
      await _showErrorDialog(displayMessage);
    } else if (_isAuthExpiry(statusCode, data)) {
      await _showSessionExpiredDialog();
    } else {
      await _showErrorDialog(message);
    }

    return handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      ),
    );
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isConnectivityError(err)) {
      final shouldRetry = await _showNoInternetDialog();
      if (shouldRetry) {
        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }
    return handler.next(err);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool _isAuthExpiry(int statusCode, dynamic data) {
    if (statusCode != 403 && statusCode != 401) return false;
    final message = data is Map ? data['message'] as String? : null;
    return message?.toLowerCase().contains('token') == true;
  }

  bool _isConnectivityError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.error is SocketException;
  }

  String _extractMessage(dynamic data, int? statusCode) {
    String errorMessage = "An error occurred";
    final errorResponse = data["message"];
    AppLogger.e("Interceptor Error: $errorResponse");
    AppLogger.e("Interceptor Error Runtime: ${errorResponse.runtimeType}");

    if (errorResponse.runtimeType == String) {
      errorMessage = errorResponse;
    } else {
      final decoded = jsonDecode(errorResponse);

      if (decoded is List) {
        final errors = decoded
            .whereType<Map<String, dynamic>>()
            .map(ApiErrorDetail.fromJson)
            .toList();
        errorMessage = errors.isNotEmpty ? errors.first.message : errorMessage;
      } else if (decoded is Map) {
        errorMessage = decoded['message'] ?? errorMessage;
      } else {
        errorMessage = errorResponse;
      }
    }

    return errorMessage;
  }

  String? _extract422Errors(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is! Map<String, dynamic>) return null;
    final lines = errors.values
        .expand((e) => e is List ? e.cast<String>() : [e.toString()])
        .join('\n');
    return lines.isNotEmpty ? lines : null;
  }

  Future<bool> _showNoInternetDialog() async {
    if (_isDialogShowing) return false;
    _isDialogShowing = true;

    final completer = Completer<bool>();
    final context = rootContext;

    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => NoInternetDialog(
          onCancel: () {
            _isDialogShowing = false;
            completer.complete(false);
          },
          onRetry: () {
            _isDialogShowing = false;
            completer.complete(true);
          },
        ),
      );
    } else {
      _isDialogShowing = false;
      completer.complete(false);
    }

    return completer.future;
  }

  Future<void> _showErrorDialog(String errorMessage) async {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    final context = rootContext;
    if (context != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CustomErrorDialog(
          errorMessage: errorMessage,
          onDismiss: () {
            _isDialogShowing = false;
          },
        ),
      );
    } else {
      _isDialogShowing = false;
    }
  }

  Future<void> _showSessionExpiredDialog() async {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    final context = rootContext;
    if (context != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => SessionExpiredDialog(
          onLoginPressed: () {
            _isDialogShowing = false;
            TokenStorage.deleteAccessToken();
            router.go(Paths.LOGIN);
          },
        ),
      );
    } else {
      _isDialogShowing = false;
    }
  }
}
