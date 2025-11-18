// ignore: file_names
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

import '../repositories/opportunity_repository.dart';

class PublishOpportunityUseCase {
  final OpportunityRepository _repository;

  PublishOpportunityUseCase(this._repository);

  Future<Opportunity> call({required int id}) async {
    return await _repository.publishOpportunity(id);
  }
}