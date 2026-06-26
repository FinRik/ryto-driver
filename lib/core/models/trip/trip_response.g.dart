// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripResponse _$TripResponseFromJson(Map<String, dynamic> json) => TripResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Trip>[],
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TripResponseToJson(TripResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta?.toJson(),
    };
