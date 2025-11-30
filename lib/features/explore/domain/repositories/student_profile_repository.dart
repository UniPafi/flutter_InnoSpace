import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';

abstract class StudentProfileRepository {
  Future<StudentProfile> getStudentProfile(int profileId);
}