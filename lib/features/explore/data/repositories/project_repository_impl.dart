import 'package:flutter_innospace/features/explore/data/dao/favorite_dao.dart';
import 'package:flutter_innospace/features/explore/data/models/favorite_project_entity.dart';
import 'package:flutter_innospace/features/explore/data/models/project_dto.dart';
import 'package:flutter_innospace/features/explore/data/services/project_service.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectService _service;
  final FavoriteDao _dao;

  ProjectRepositoryImpl(this._service, this._dao);

  @override
  Future<List<Project>> getExploreProjects() async {
    final projectDtos = await _service.getAllProjects();

    final List<Project> projects = [];
    for (var dto in projectDtos) {
      if (dto.status == 'PUBLISHED') {
        final isFav = await _dao.isFavorite(dto.id);
        
        projects.add(dto.toEntity(isFavorite: isFav));
      }
    }
    
    return projects;
  }

  @override
  Future<bool> isProjectFavorite(int projectId) {
    return _dao.isFavorite(projectId);
  }

  @override
  Future<void> toggleFavoriteStatus(int projectId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      await _dao.delete(projectId);
    } else {
      await _dao.insert(FavoriteProjectEntity(id: projectId));
    }
  }

@override
  Future<List<Project>> getFavoriteProjects() async {
    final List<int> favoriteIds = await _dao.fetchAllIds();

    if (favoriteIds.isEmpty) {
      return []; 
    }

    
    final List<ProjectDto> projectDtos = await _service.getAllProjects();
    
    final Set<int> favoriteIdsSet = favoriteIds.toSet();

    final List<Project> favoriteProjects = projectDtos
        .where((dto) => favoriteIdsSet.contains(dto.id))
        .where((dto) => dto.status == 'PUBLISHED')
        .map((dto) => dto.toEntity(isFavorite: true))
        .toList();

    return favoriteProjects;
  }
}