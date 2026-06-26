import '../meta.dart';
import 'bank.dart';

class BanksResponse {
  final bool? status;
  final String? message;
  final List<Bank>? data;
  final Meta? meta;

  BanksResponse({
    this.status,
    this.message,
    this.data,
    this.meta,
  });

  factory BanksResponse.fromJson(Map<String, dynamic> json) {
    return BanksResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Bank.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}