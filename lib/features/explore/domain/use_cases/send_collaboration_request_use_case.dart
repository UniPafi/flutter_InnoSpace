import 'package:flutter_innospace/features/explore/domain/repositories/collaboration_repository.dart';

class SendCollaborationRequestUseCase {
  final CollaborationRepository _repository;

  SendCollaborationRequestUseCase(this._repository);

  Future<void> call(int projectId) async {
    await _repository.sendCollaborationRequest(projectId);
  }
}