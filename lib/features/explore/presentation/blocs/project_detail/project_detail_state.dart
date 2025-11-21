import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';

class ProjectDetailState extends Equatable {
  final Status status;
  final Project? project;
  final String? errorMessage;

  const ProjectDetailState({
    this.status = Status.initial,
    this.project,
    this.errorMessage,
  });

  ProjectDetailState copyWith({
    Status? status,
    Project? project,
    String? errorMessage,
  }) {
    return ProjectDetailState(
      status: status ?? this.status,
      project: project ?? this.project,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, project, errorMessage];
}