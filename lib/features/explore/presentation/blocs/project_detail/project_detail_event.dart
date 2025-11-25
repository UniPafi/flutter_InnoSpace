import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchProjectDetail extends ProjectDetailEvent {
  final int projectId;
  const FetchProjectDetail(this.projectId);
  @override
  List<Object> get props => [projectId];
}

class SendCollaborationRequest extends ProjectDetailEvent {
  final int projectId;

  const SendCollaborationRequest(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ResetCollaborationRequestStatus extends ProjectDetailEvent {}