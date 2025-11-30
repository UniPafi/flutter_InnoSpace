import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';



class GetProjectDetailUseCase {
  final ProjectRepository _repository;

  GetProjectDetailUseCase(this._repository);

  Future<Project> call(int projectId) async {
    return await _repository.getProjectById(projectId);
  }
}