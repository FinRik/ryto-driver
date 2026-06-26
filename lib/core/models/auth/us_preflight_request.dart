import 'dart:io';

class USPreflightRequest {
  final String ssn;
  final String dob;
  final String driverLicenseNumber;
  final String driverLicenseState;
  final String zipcode;
  final File licenseFront;
  final File licenseBack;

  USPreflightRequest({
    required this.ssn,
    required this.dob,
    required this.driverLicenseNumber,
    required this.driverLicenseState,
    required this.zipcode,
    required this.licenseFront,
    required this.licenseBack,
  });

  USPreflightRequest copyWith({
    String? ssn,
    String? dob,
    String? driverLicenseNumber,
    String? driverLicenseState,
    String? zipcode,
    File? licenseFront,
    File? licenseBack,
  }) {
    return USPreflightRequest(
      ssn: ssn ?? this.ssn,
      dob: dob ?? this.dob,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverLicenseState: driverLicenseState ?? this.driverLicenseState,
      zipcode: zipcode ?? this.zipcode,
      licenseFront: licenseFront ?? this.licenseFront,
      licenseBack: licenseBack ?? this.licenseBack,
    );
  }
}