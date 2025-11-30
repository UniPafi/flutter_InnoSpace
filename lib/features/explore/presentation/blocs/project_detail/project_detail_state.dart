import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';

class ProjectDetailState extends Equatable {
  final Status status;
  final Project? project;
  final String? errorMessage;
  final Status requestStatus; 
  final String? requestError;

  const ProjectDetailState({
    this.status = Status.initial,
    this.project,
    this.errorMessage,
    this.requestStatus = Status.initial, 
    this.requestError, 
    
  });

  ProjectDetailState copyWith({
    Status? status,
    Project? project,
    String? errorMessage,
    Status? requestStatus, 
    String? requestError, 
  }) {
    return ProjectDetailState(
      status: status ?? this.status,
      project: project ?? this.project,
      errorMessage: errorMessage,
      requestStatus: requestStatus ?? this.requestStatus, 
      requestError: requestError
    );
  }

  @override
  List<Object?> get props => [status, project, errorMessage];
}