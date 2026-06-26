class ApiErrorResponse {
  final List<ApiErrorDetail> message;
  final String error;
  final int statusCode;

  ApiErrorResponse({
    required this.message,
    required this.error,
    required this.statusCode,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    final rawMessage = json['message'];
    return ApiErrorResponse(
      message: rawMessage is List
          ? rawMessage
          .whereType<Map<String, dynamic>>()
          .map(ApiErrorDetail.fromJson)
          .toList()
          : [],
      error: json['error'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 0,
    );
  }
}

class ApiErrorDetail {
  final String code;
  final List<String> path;
  final String message;

  ApiErrorDetail({
    required this.code,
    required this.path,
    required this.message,
  });

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) {
    return ApiErrorDetail(
      code: json['code'] as String? ?? '',
      path: (json['path'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      message: json['message'] as String? ?? '',
    );
  }
}