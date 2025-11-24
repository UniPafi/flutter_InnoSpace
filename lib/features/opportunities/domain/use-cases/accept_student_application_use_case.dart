import '../repositories/opportunity_repository.dart';

class AcceptStudentApplicationUseCase {
  final OpportunityRepository _repository;

  AcceptStudentApplicationUseCase(this._repository);

  Future<void> call({required int applicationId}) async {
    await _repository.acceptStudentApplication(applicationId);
  }
}