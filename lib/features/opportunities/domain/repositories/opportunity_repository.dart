import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';

abstract class OpportunityRepository {
  Future<List<Opportunity>> getMyOpportunities();
  Future<Opportunity> getOpportunityById(int id);
  Future<Opportunity> createOpportunity(CreateOpportunityDto createDto);
  Future<Opportunity> publishOpportunity(int id);
  Future<Opportunity> closeOpportunity(int id);
  
  Future<void> deleteOpportunity(int id);

  Future<List<StudentApplication>> getStudentApplications(int opportunityId);

  Future<void> acceptStudentApplication(int applicationId);
  Future<void> rejectStudentApplication(int applicationId);
}