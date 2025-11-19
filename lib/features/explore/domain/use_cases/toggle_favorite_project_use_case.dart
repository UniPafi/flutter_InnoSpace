import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';

class ToggleFavoriteProjectUseCase {
  final ProjectRepository _repository;

  ToggleFavoriteProjectUseCase(this._repository);

  Future<void> call(int projectId, bool isCurrentlyFavorite) async {
  
    await _repository.toggleFavoriteStatus(projectId, isCurrentlyFavorite);
  }
}