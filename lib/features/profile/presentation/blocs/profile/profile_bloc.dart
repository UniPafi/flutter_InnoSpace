import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';
import 'package:flutter_innospace/features/profile/domain/use_cases/get_manager_profile_use_case.dart';
import 'package:flutter_innospace/features/profile/domain/use_cases/update_manager_profile_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetManagerProfileUseCase _getManagerProfileUseCase;
  final UpdateManagerProfileUseCase _updateManagerProfileUseCase;

  ProfileBloc(
    this._getManagerProfileUseCase,
    this._updateManagerProfileUseCase,
  ) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    try {
      final profile = await _getManagerProfileUseCase.call(event.managerId);
      emit(state.copyWith(status: Status.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    try {
      final updatedProfile = await _updateManagerProfileUseCase.call(
        event.profile.id,
        event.profile,
      );
      emit(state.copyWith(status: Status.success, profile: updatedProfile));
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    try {
      final profile = await _getManagerProfileUseCase.call(event.managerId);
      emit(state.copyWith(status: Status.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
