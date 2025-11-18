import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';

class GetFavoriteProjectsUseCase {
  final ProjectRepository _repository;

  GetFavoriteProjectsUseCase(this._repository);

  Future<List<Project>> call() async {
 
    return await _repository.getFavoriteProjects(); // <-- Nuevo método en el repositorio
  }
}