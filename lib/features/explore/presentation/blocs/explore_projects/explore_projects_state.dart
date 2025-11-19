import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';

class ExploreState extends Equatable {
  final Status status;
  final List<Project> projects;
  final String? errorMessage;

  const ExploreState({
    this.status = Status.initial,
    this.projects = const [],
    this.errorMessage,
  });

  ExploreState copyWith({
    Status? status,
    List<Project>? projects,
    String? errorMessage,
  }) {
    return ExploreState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, projects, errorMessage];
}