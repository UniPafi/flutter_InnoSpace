part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final int managerId;

  const LoadProfile(this.managerId);

  @override
  List<Object?> get props => [managerId];
}

class UpdateProfile extends ProfileEvent {
  final ManagerProfile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class RefreshProfile extends ProfileEvent {
  final int managerId;

  const RefreshProfile(this.managerId);

  @override
  List<Object?> get props => [managerId];
}
