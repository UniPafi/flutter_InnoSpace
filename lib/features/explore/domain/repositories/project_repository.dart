import 'package:flutter_innospace/features/explore/domain/models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getExploreProjects(); 
Future<List<Project>> getFavoriteProjects();
  Future<void> toggleFavoriteStatus(int projectId, bool isCurrentlyFavorite);

  Future<bool> isProjectFavorite(int projectId); 
}