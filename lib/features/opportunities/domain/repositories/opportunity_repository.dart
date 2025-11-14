import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

abstract class OpportunityRepository {
  Future<List<Opportunity>> getMyOpportunities();
  Future<Opportunity> getOpportunityById(int id);
  Future<Opportunity> createOpportunity(CreateOpportunityDto createDto);
  Future<Opportunity> publishOpportunity(int id);
  Future<Opportunity> closeOpportunity(int id);
  // ---
  // ¡NUEVO MÉTODO AÑADIDO!
  // ---
  Future<void> deleteOpportunity(int id);
}