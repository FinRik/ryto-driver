import 'package:dio/dio.dart';

import '../../utils/logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      '🌐 Request Url:  ${options.uri}\n'
      '🌐 Request Method: [${options.method}]\n'
      '🌐 Request Header: [${options.headers.toString()}]\n'
      '🌐 Request Body: ${options.data}',
    );
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    final statusCode = response.statusCode ?? 0;

    // Handle Case 1: Standard Success (200 OK)
    if (statusCode >= 200 && statusCode < 300) {
      AppLogger.i(
        '🌐 Response Url: ${response.realUri}\n'
        '🌐 Response Method: [${response.requestOptions.method}]\n'
        '🌐 Response Status Code: ${response.statusCode}\n'
        '🌐 Response Header: [${response.headers.toString()}]\n'
        '🌐 Response Body: $data\n'
        '🌐 Response Message: ${data['message']}',
      );
    }
    // Handle Case 2: Success Code but potential "Logic Error" in body
    else {
      AppLogger.e(
        '🌐 Response Url: ${response.realUri}\n'
        '🌐 Response Method: [${response.requestOptions.method}]\n'
        '🌐 Response Status Code: ${response.statusCode}\n'
        '🌐 Response Header: [${response.headers.toString()}]\n'
        '🌐 Response Body: $data\n'
        '🌐 Response Message: ${data['message']}',
      );
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ ERROR \n'
      '❌ Url: ${err.requestOptions.path}\n'
      '❌ Method: ${err.requestOptions.method}\n'
      '❌ Header: ${err.requestOptions.headers.toString()}\n'
      '❌ Code: [${err.response?.statusCode}]\n'
      '❌ Body: [${err.response?.data}]',
    );
    return handler.next(err);
  }
}
