import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';
import 'package:flutter_innospace/features/profile/domain/repositories/profile_repository.dart';

class GetManagerProfileUseCase {
  final ProfileRepository _repository;

  GetManagerProfileUseCase(this._repository);

  Future<ManagerProfile> call(int managerId) async {
    return await _repository.getManagerProfile(managerId);
  }
}
