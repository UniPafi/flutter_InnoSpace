import 'package:flutter_innospace/features/explore/data/services/collaboration_service.dart';
import 'package:flutter_innospace/features/explore/domain/repositories/collaboration_repository.dart';

class CollaborationRepositoryImpl implements CollaborationRepository {
  final CollaborationService _service;

  CollaborationRepositoryImpl(this._service);

  @override
  Future<void> sendCollaborationRequest(int projectId) async {
    await _service.sendRequest(projectId);
  }
}