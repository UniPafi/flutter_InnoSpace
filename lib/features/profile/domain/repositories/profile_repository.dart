import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';

abstract class ProfileRepository {
  Future<ManagerProfile> getManagerProfile(int managerId);
  Future<ManagerProfile> updateManagerProfile(
      int managerId, ManagerProfile profile);
}
