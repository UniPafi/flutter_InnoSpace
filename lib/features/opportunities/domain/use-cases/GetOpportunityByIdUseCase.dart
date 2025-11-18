// ignore_for_file: file_names

import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

import '../repositories/opportunity_repository.dart';

class GetOpportunityByIdUseCase {
  final OpportunityRepository _repository;

  GetOpportunityByIdUseCase(this._repository);

  Future<Opportunity> call({required int id}) async {
    return await _repository.getOpportunityById(id);
  }
}