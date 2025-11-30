import 'package:equatable/equatable.dart';

class StudentApplication extends Equatable {
  final int id;
  final int opportunityId;
  final int studentId;
  final String studentName;
  final String studentPhotoUrl;
  final String managerResponse;
  // Nuevos campos
  final String studentDescription;
  final String studentPhoneNumber;
  final List<String> studentSkills;

  const StudentApplication({
    required this.id,
    required this.opportunityId,
    required this.studentId,
    required this.studentName,
    required this.studentPhotoUrl,
    required this.managerResponse,
    required this.studentDescription,
    required this.studentPhoneNumber,
    required this.studentSkills,
  });

  @override
  List<Object?> get props => [
        id,
        opportunityId,
        studentId,
        studentName,
        studentPhotoUrl,
        managerResponse,
        studentDescription,
        studentPhoneNumber,
        studentSkills,
      ];
}