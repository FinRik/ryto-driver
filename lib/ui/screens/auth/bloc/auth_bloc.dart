import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/auth/driver_profile_request.dart';
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
        emit(AuthFailure(e.toString()));
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
        emit(AuthFailure(e.toString()));
      }
    });

    on<VerifyPhoneRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.verifyPhone(event.code);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("OTP verification failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
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
        emit(AuthFailure(e.toString()));
      }
    });

    on<UpdateProfileRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.updateProfile(event.request);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("Profile update failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<UpdateProfilePicRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final success = await repo.updateProfilePic(event.image);

        if (success) {
          emit(AuthSuccess());
        } else {
          emit(const AuthFailure("Profile picture upload failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
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
        emit(AuthFailure(e.toString()));
      }
    });

  }
}