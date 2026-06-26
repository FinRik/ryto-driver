import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/custom_dio_exception.dart';
import '../../../../core/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.login(event.phone);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("Login failed"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.register(event.phone);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("Registration failed"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });

    on<VerifyLoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        // If successful, this will complete. If it fails, it throws an exception.
        await repo.verifyLogin(event.phone, event.code);

        // If no exception was thrown, it's a guaranteed success
        emit(AuthSuccess());
      } on ExceptionNotACustomer catch (e) {
        // Catches role restriction issues
        emit(AuthFailure(e.message));
      } on ExceptionUnverifiedAccount catch (e) {
        // Catches unverified accounts
        emit(AuthFailure(e.message));
      } on ExceptionInvalidCredentials catch (e) {
        // Catches invalid OTP / 400 bad requests
        emit(AuthFailure(e.message));
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });

    on<VerifyOtpRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.verifyOtp(event.code);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("OTP verification failed"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });

    on<ResendOtpRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.resendOtp();

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("Failed to resend OTP"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.logout();

        if (success) {
          emit(AuthInitial());
        } else {
          emit(const AuthFailure("Logout failed"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });
  }
}
