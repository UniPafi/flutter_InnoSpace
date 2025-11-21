import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/student_profile_repository.dart';

class GetStudentProfileUseCase {
  final StudentProfileRepository _repository;

  GetStudentProfileUseCase(this._repository);

  Future<StudentProfile> call(int profileId) async {
    return await _repository.getStudentProfile(profileId);
  }
}

