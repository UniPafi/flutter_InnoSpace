import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object> get props => [];
}

// 1. Evento UNIFICADO para cargar la lista
class FetchProjects extends ExploreEvent {
  // Bandera para diferenciar: false = Explorar, true = Favoritos
  final bool isFavoriteView; 

  const FetchProjects({this.isFavoriteView = false});

  @override
  List<Object> get props => [isFavoriteView];
}

// 2. Evento para cambiar el estado de favorito (se mantiene igual)
class ToggleFavoriteProject extends ExploreEvent {
  final int projectId;

  const ToggleFavoriteProject(this.projectId);

  @override
  List<Object> get props => [projectId];
}