part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String phone;
  const LoginRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

class RegisterRequested extends AuthEvent {
  final String phone;
  const RegisterRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyPhoneRequested extends AuthEvent {
  final String code;
  const VerifyPhoneRequested(this.code);

  @override
  List<Object?> get props => [code];
}

class ResendOtpRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

/// NEW EVENTS

class UpdateProfileRequested extends AuthEvent {
  final DriverProfileRequest request;

  const UpdateProfileRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateProfilePicRequested extends AuthEvent {
  final File image;

  const UpdateProfilePicRequested(this.image);

  @override
  List<Object?> get props => [image];
}