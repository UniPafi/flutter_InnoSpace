import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';
import 'package:flutter_innospace/features/profile/domain/repositories/profile_repository.dart';

class UpdateManagerProfileUseCase {
  final ProfileRepository _repository;

  UpdateManagerProfileUseCase(this._repository);

  Future<ManagerProfile> call(int managerId, ManagerProfile profile) async {
    return await _repository.updateManagerProfile(managerId, profile);
  }
}
