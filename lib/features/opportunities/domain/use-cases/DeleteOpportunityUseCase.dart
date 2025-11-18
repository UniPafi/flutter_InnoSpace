import '../repositories/opportunity_repository.dart';

class DeleteOpportunityUseCase {
  final OpportunityRepository _repository;

  DeleteOpportunityUseCase(this._repository);

  Future<void> call({required int id}) async {
    await _repository.deleteOpportunity(id);
  }
}