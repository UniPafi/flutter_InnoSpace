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
  final GetFavoriteProjectsUseCase _getFavoriteProjectsUseCase; // INYECCIÓN
  final ToggleFavoriteProjectUseCase _toggleFavoriteProjectUseCase;

  ExploreBloc(
    this._getExploreProjectsUseCase,
    this._getFavoriteProjectsUseCase, // PASAR Use Case
    this._toggleFavoriteProjectUseCase,
  ) : super(const ExploreState()) {
    on<FetchProjects>(_onFetchProjects); // Manejador unificado
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
      // 1. Encontrar el proyecto actual en el estado
      final Project? currentProject = state.projects.firstWhere(
        (p) => p.id == projectId,
      );

      if (currentProject == null) return;

      // 2. Determinar el nuevo estado
      final bool isCurrentlyFavorite = currentProject.isFavorite;

      // 3. Llama al Use Case para actualizar la DB local (asíncrono)
      // Nota: No bloqueamos la UI aquí con 'loading' a menos que sea un requisito específico.
      await _toggleFavoriteProjectUseCase.call(
        projectId,
        isCurrentlyFavorite,
      );

      // 4. Actualizar la lista en el estado de forma inmutable
      final updatedProjects = state.projects.map((p) {
        return p.id == projectId
            ? p.copyWith(isFavorite: !isCurrentlyFavorite)
            : p;
      }).toList();

      emit(state.copyWith(
        projects: updatedProjects,
        // Mantener el status como success ya que la operación fue local y exitosa
      ));
    } catch (e) {
      // Si falla la operación de DB (raro), emitir un error temporal
      // Note: Idealmente, usaríamos un listener para mostrar un SnackBar
      emit(state.copyWith(errorMessage: 'Fallo al actualizar favorito: ${e.toString()}'));
      
      // Rápidamente volver al estado success para no bloquear la lista
      emit(state.copyWith(errorMessage: null)); 
    }
  }
}