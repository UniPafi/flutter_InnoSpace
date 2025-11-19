import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object> get props => [];
}

class FetchProjects extends ExploreEvent {
  final bool isFavoriteView; 

  const FetchProjects({this.isFavoriteView = false});

  @override
  List<Object> get props => [isFavoriteView];
}

class ToggleFavoriteProject extends ExploreEvent {
  final int projectId;

  const ToggleFavoriteProject(this.projectId);

  @override
  List<Object> get props => [projectId];
}