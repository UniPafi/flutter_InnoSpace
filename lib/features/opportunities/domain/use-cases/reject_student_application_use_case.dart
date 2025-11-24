import '../repositories/opportunity_repository.dart';

class RejectStudentApplicationUseCase {
  final OpportunityRepository _repository;

  RejectStudentApplicationUseCase(this._repository);

  Future<void> call({required int applicationId}) async {
    await _repository.rejectStudentApplication(applicationId);
  }
}