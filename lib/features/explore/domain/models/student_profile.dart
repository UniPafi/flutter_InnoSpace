import 'package:equatable/equatable.dart';

class StudentProfile extends Equatable {
  final int id;
  final int userId;
  final String name;
  final String photoUrl; 
  final String description;
  final String phoneNumber;
  final String portfolioUrl;
  final List<String> skills;
  final List<String> experiences;

  const StudentProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.phoneNumber,
    required this.portfolioUrl,
    required this.skills,
    required this.experiences,
  });

  @override
  List<Object> get props => [id, userId, name, description, phoneNumber, portfolioUrl, skills, experiences];
}