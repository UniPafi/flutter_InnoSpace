import 'package:flutter_innospace/features/explore/domain/models/project.dart';

class ProjectDto extends Project {
  const ProjectDto({
    required super.id,
    required super.studentId,
    required super.title,
    required super.description,
    required super.summary,
    required super.category,
    required super.status,
    super.isFavorite, 
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as int,
     
      studentId: json['studentId'] as int, 
      title: json['title'] as String,
      description: json['description'] as String,
      summary: json['summary'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
    );
  }

  Project toEntity({bool isFavorite = false}) {
    return Project(
      id: id,
      studentId: studentId,
      title: title,
      description: description,
      summary: summary,
      category: category,
      status: status,
      isFavorite: isFavorite, 
    );
  }
}