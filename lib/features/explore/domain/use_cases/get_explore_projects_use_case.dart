import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';

class GetExploreProjectsUseCase {
  final ProjectRepository _repository;

  GetExploreProjectsUseCase(this._repository);

  Future<List<Project>> call() async {
 
    return await _repository.getExploreProjects();
  }
}