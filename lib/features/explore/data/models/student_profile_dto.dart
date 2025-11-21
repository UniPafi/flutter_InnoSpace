import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';

class StudentProfileDto extends StudentProfile {
  const StudentProfileDto({
    required super.id,
    required super.userId,
    required super.name,
    required super.photoUrl,
    required super.description,
    required super.phoneNumber,
    required super.portfolioUrl,
    required super.skills,
    required super.experiences,
  });

  factory StudentProfileDto.fromJson(Map<String, dynamic> json) {
    return StudentProfileDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String, // Base64 string
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      portfolioUrl: json['portfolioUrl'] as String,
      skills: List<String>.from(json['skills'] as List),
      experiences: List<String>.from(json['experiences'] as List),
    );
  }

  StudentProfile toEntity() {
    return StudentProfile(
      id: id,
      userId: userId,
      name: name,
      photoUrl: photoUrl,
      description: description,
      phoneNumber: phoneNumber,
      portfolioUrl: portfolioUrl,
      skills: skills,
      experiences: experiences,
    );
  }
}