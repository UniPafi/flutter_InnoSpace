import 'package:flutter_innospace/features/explore/data/services/student_profile_service.dart';
import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/student_profile_repository.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileService _service;

  StudentProfileRepositoryImpl(this._service);

  @override
  Future<StudentProfile> getStudentProfile(int profileId) async {
    final dto = await _service.getStudentProfile(profileId);
    return dto.toEntity();
  }
}