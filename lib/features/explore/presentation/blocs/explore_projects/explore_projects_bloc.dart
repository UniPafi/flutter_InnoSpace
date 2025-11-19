import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_explore_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_favorite_projects_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/toggle_favorite_project_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExploreProjectsUseCase _getExploreProjectsUseCase;
  final GetFavoriteProjectsUseCase _getFavoriteProjectsUseCase; 
  final ToggleFavoriteProjectUseCase _toggleFavoriteProjectUseCase;

  ExploreBloc(
    this._getExploreProjectsUseCase,
    this._getFavoriteProjectsUseCase,
    this._toggleFavoriteProjectUseCase,
  ) : super(const ExploreState()) {
    on<FetchProjects>(_onFetchProjects);
    on<ToggleFavoriteProject>(_onToggleFavoriteProject);
  }


  Future<void> _onFetchProjects(
    FetchProjects event,
    Emitter<ExploreState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    try {
      final List<Project> projects;

      if (event.isFavoriteView) {
        projects = await _getFavoriteProjectsUseCase.call();
      } else {
        projects = await _getExploreProjectsUseCase.call();
      }

      emit(state.copyWith(
        status: Status.success,
        projects: projects,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }


  Future<void> _onToggleFavoriteProject(
    ToggleFavoriteProject event,
    Emitter<ExploreState> emit,
  ) async {
    try {
      final projectId = event.projectId;
     
      final Project? currentProject = state.projects.firstWhere(
        (p) => p.id == projectId,
      );

      if (currentProject == null) return;

      final bool isCurrentlyFavorite = currentProject.isFavorite;

    
      await _toggleFavoriteProjectUseCase.call(
        projectId,
        isCurrentlyFavorite,
      );

     
      final updatedProjects = state.projects.map((p) {
        return p.id == projectId
            ? p.copyWith(isFavorite: !isCurrentlyFavorite)
            : p;
      }).toList();

      emit(state.copyWith(
        projects: updatedProjects,
      ));
    } catch (e) {
   
      emit(state.copyWith(errorMessage: 'Fallo al actualizar favorito: ${e.toString()}'));
      

      emit(state.copyWith(errorMessage: null)); 
    }
  }
}