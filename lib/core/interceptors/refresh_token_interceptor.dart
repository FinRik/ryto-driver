import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../services/dio_service.dart';
import '../../app/api_urls.dart';

// class RefreshTokenInterceptor extends Interceptor {
//   final Dio _dio;
//
//   RefreshTokenInterceptor(this._dio);
//
//   @override
//   Future<void> onError(
//       DioException err, ErrorInterceptorHandler handler) async {
//
//     if (err.response?.statusCode == 401) {
//
//         try {
//
//           final refreshToken = await getStoredRefreshToken();
//
//           final response = await _dio.post(
//             ApiUrls.refreshToken,
//             data: {"refresh_token": refreshToken},
//           );
//
//           final newToken = response.data["token"];
//
//           await saveToken(newToken);
//
//           GetIt.I<DioService>().reset(newToken);
//
//           /// retry original request
//           final opts = err.requestOptions;
//
//           final cloneReq = await _dio.request(
//             opts.path,
//             options: Options(
//               method: opts.method,
//               headers: opts.headers,
//             ),
//             data: opts.data,
//             queryParameters: opts.queryParameters,
//           );
//
//           return handler.resolve(cloneReq);
//
//         } catch (e) {
//           /// logout user
//           // router.go('/login');
//
//           return handler.reject(err);
//         }
//       }
//
//     return handler.next(err);
//   }
// }

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  RefreshTokenInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Assume you have a method to refresh the token
        final newToken = await _refreshToken();

        // Update the failed request with the new token
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // Create a clone of the request to retry it
        final opts = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        );

        final response = await dio.request(
          err.requestOptions.path,
          options: opts,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(response);
      } catch (e) {
        // If refresh fails, pass the error along (e.g., force logout)
        return handler.next(err);
      }
    }
    return super.onError(err, handler);
  }

  Future<String> _refreshToken() async {
    // Implement your actual token refresh logic here
    return "new_access_token";
  }
}