// ignore: file_names
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

class GetMyOpportunitiesUseCase {
  final OpportunityRepository _repository;

  GetMyOpportunitiesUseCase(this._repository);

  Future<List<Opportunity>> call() async {
    return await _repository.getMyOpportunities();
  }
}