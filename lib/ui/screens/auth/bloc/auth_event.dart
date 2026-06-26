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

class VerifyLoginRequested extends AuthEvent {
  final String phone;
  final String code;
  const VerifyLoginRequested({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}

class VerifyOtpRequested extends AuthEvent {
  final String code;
  const VerifyOtpRequested(this.code);

  @override
  List<Object?> get props => [code];
}

class ResendOtpRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}