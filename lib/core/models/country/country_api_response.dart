class CountryApiResponse<T> {
  final bool? error;
  final String? msg;
  final T? data;

  CountryApiResponse({
    this.error,
    this.msg,
    this.data,
  });

  factory CountryApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return CountryApiResponse<T>(
      error: json['error'],
      msg: json['msg'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}