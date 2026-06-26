// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileRequest _$ProfileRequestFromJson(Map<String, dynamic> json) =>
    ProfileRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      homeAddress: json['homeAddress'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      profilePicture: json['profilePicture'] as String,
    );

Map<String, dynamic> _$ProfileRequestToJson(ProfileRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth,
      'homeAddress': instance.homeAddress,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'profilePicture': instance.profilePicture,
    };
