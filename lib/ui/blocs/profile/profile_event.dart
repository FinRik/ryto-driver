part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final ProfileRequest request;

  const UpdateProfileRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateProfilePicRequested extends ProfileEvent {
  final File image;

  const UpdateProfilePicRequested(this.image);

  @override
  List<Object?> get props => [image];
}