import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../app/api_urls.dart';
import '../../../core/models/user/profile_request.dart';
import '../../../../../core/repos/auth_repo.dart';
import '../../../core/models/user/user_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  final AuthRepo repo;

  ProfileBloc(this.repo) : super(const ProfileState()) {
    on<FetchUserProfile>(_onFetchProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UpdateProfilePicRequested>(_onUpdatePic);
  }

  // 1. FETCH PROFILE
  Future<void> _onFetchProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await repo.fetchProfile();
      emit(state.copyWith(status: ProfileStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }

  // 2. UPDATE PROFILE DATA (Text/Details)
  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final success = await repo.updateProfile(event.request);
      if (success) {
        // Fetch the fresh data from the server
        final updatedUser = await repo.fetchProfile();

        emit(
          state.copyWith(
            status: ProfileStatus.success,
            user: updatedUser,
            message: "Update Successful", // Now this matches your UI listener
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            message: "Update failed",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, message: e.toString()),
      );
    }
  }

  // 3. UPDATE PROFILE PICTURE (Files)
  Future<void> _onUpdatePic(
    UpdateProfilePicRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(uploadStatus: UploadStatus.uploading));
    try {
      final newImageUrl = await repo.updateProfilePic(event.image);
      if (newImageUrl != null) {
        final currentPic = newImageUrl.startsWith('http')
            ? newImageUrl
            : "${ApiUrls.baseUrl}$newImageUrl";
        emit(
          state.copyWith(
            uploadStatus: UploadStatus.success,
            uploadedImagUrl: currentPic,
          ),
        );
      } else {
        emit(state.copyWith(uploadStatus: UploadStatus.failure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          uploadStatus: UploadStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) =>
      ProfileState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ProfileState state) => state.toJson();
}
