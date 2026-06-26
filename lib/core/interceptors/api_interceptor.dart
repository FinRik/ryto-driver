import 'package:dio/dio.dart';

import '../../utils/storage/token_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // if (options.extra['requiresAuthToken'] == true) {
    if (options.extra['isPublic'] != true) {
      final token = await TokenStorage.getAccessToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
