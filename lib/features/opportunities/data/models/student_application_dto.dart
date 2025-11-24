import 'package:flutter_innospace/features/opportunities/data/models/student_profile_dto.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';

class StudentApplicationDto {
  final int id;
  final int opportunityId;
  final String opportunityTitle;
  final String opportunityDescription;
  final int studentId;
  final String studentName;
  final String studentPhotoUrl;
  final String managerResponse;

  StudentApplicationDto({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.opportunityDescription,
    required this.studentId,
    required this.studentName,
    required this.studentPhotoUrl,
    required this.managerResponse,
  });

  factory StudentApplicationDto.fromJson(Map<String, dynamic> json) {
    return StudentApplicationDto(
      id: json['id'] as int? ?? 0,
      opportunityId: json['opportunityId'] as int? ?? 0,
      opportunityTitle: json['opportunityTitle'] as String? ?? '',
      opportunityDescription: json['opportunityDescription'] as String? ?? '',
      studentId: json['studentId'] as int? ?? 0,
      studentName: json['studentName'] as String? ?? 'Desconocido',
      studentPhotoUrl: json['studentPhotoUrl'] as String? ?? '',
      managerResponse: json['managerResponse'] as String? ?? '',
    );
  }

  // Método normal (sin datos extra)
  StudentApplication toDomain() {
    return StudentApplication(
      id: id,
      opportunityId: opportunityId,
      studentId: studentId,
      studentName: studentName,
      studentPhotoUrl: studentPhotoUrl,
      managerResponse: managerResponse,
      studentDescription: '',
      studentPhoneNumber: '',
      studentSkills: const [],
    );
  }

  // Método enriquecido (con datos del perfil)
  StudentApplication toDomainWithProfile(StudentProfileDto profile) {
    return StudentApplication(
      id: id,
      opportunityId: opportunityId,
      studentId: studentId,
      studentName: studentName,
      studentPhotoUrl: studentPhotoUrl,
      managerResponse: managerResponse,
      studentDescription: profile.description,
      studentPhoneNumber: profile.phoneNumber,
      studentSkills: profile.skills,
    );
  }
}