import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

class GetStudentApplicationsUseCase {
  final OpportunityRepository _repository;

  GetStudentApplicationsUseCase(this._repository);

  Future<List<StudentApplication>> call({required int opportunityId}) async {
    return await _repository.getStudentApplications(opportunityId);
  }
}