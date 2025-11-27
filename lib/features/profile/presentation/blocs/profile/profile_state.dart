part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Status status;
  final ManagerProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = Status.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    Status? status,
    ManagerProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
