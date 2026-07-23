part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }
enum UploadStatus { idle, uploading, success, failure }
enum TokenStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UploadStatus uploadStatus;
  final TokenStatus tokenStatus;
  final String? uploadedImagUrl;
  final UserEntity? user;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.uploadStatus = UploadStatus.idle,
    this.tokenStatus = TokenStatus.initial,
    this.uploadedImagUrl,
    this.user,
    this.message,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UploadStatus? uploadStatus,
    TokenStatus? tokenStatus,
    String? uploadedImagUrl,
    UserEntity? user,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      tokenStatus: tokenStatus ?? this.tokenStatus,
      uploadedImagUrl: uploadedImagUrl ?? this.uploadedImagUrl,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, uploadStatus, tokenStatus, uploadedImagUrl, user, message];

  Map<String, dynamic> toJson() => {'user': user?.toJson()};

  factory ProfileState.fromJson(Map<String, dynamic> json) {
    return ProfileState(
      user: json['user'] != null ? UserEntity.fromJson(json['user']) : null,
    );
  }
}
