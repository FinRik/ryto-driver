import 'package:dio/dio.dart';

import '../../app/api_urls.dart';
import '../interceptors/api_interceptor.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logging_interceptor.dart';

class DioService {
  late Dio _dio;
  final Duration _timeout = const Duration(milliseconds: 25 * 1000);

  DioService() {
    _initDioClient();
  }

  void _initDioClient({String? authToken}) {
    print("About to set client");
    _dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));
    _dio.options.responseType = ResponseType.json;
    _dio.options.headers["Accept"] = "application/vnd.api+json";
    _dio.options.headers["content-type"] = "application/json";
    // _dio.options.headers["Authorization"] = "Bearer $authToken";
    _dio.options.connectTimeout = _timeout;
    _dio.options.receiveTimeout = _timeout;
    _dio.options.sendTimeout = _timeout;
    // Accept all status codes and handle them manually
    // Or if you only want to handle 4xx errors:
    // return status! < 500;
    _dio.options.validateStatus = (status) => true;
    // _dio.interceptors.addAll([
    //   ApiInterceptor(),
    //   ConnectionInterceptor(),
    //   InterceptorWrappers(),
    //   LoggingInterceptor(),
    // ]);
    _dio.interceptors.addAll([
      ApiInterceptor(),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
    print("Done setting client");
  }

  void reset(String authToken) {
    print("User Token: $authToken");
    _dio.options.headers["Authorization"] = "Bearer $authToken";
  }

  Dio get client => _dio;
}
