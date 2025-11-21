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