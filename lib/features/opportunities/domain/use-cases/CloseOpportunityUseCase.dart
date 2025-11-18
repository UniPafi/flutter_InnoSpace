// ignore: file_names
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

import '../repositories/opportunity_repository.dart';

class CloseOpportunityUseCase {
  final OpportunityRepository _repository;

  CloseOpportunityUseCase(this._repository);

  Future<Opportunity> call({required int id}) async {
    return await _repository.closeOpportunity(id);
  }
}