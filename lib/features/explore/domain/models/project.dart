import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';

class Project extends Equatable {
  final int id;
  final int studentId; 
  final String title;
  final String description;
  final String summary;
  final String category;
  final String status;
  final bool isFavorite; 
  final StudentProfile? studentProfile;

  
  const Project({
    required this.id,
    required this.studentId,
    required this.title,
    required this.description,
    required this.summary,
    required this.category,
    required this.status,
    this.isFavorite = false, 
    this.studentProfile,
  });

  Project copyWith({
    int? id,
    int? studentId,
    String? title,
    String? description,
    String? summary,
    String? category,
    String? status,
    bool? isFavorite,
    StudentProfile? studentProfile,
  }) {
    return Project(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      description: description ?? this.description,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      studentProfile: studentProfile ?? this.studentProfile,
    );
  }

  @override
  List<Object> get props => [
        id,
        studentId,
        title,
        description,
        summary,
        category,
        status,
        isFavorite,
        studentProfile ?? '',
      ];
}