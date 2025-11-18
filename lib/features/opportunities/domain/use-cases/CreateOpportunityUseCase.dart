


import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

class CreateOpportunityUseCase {
  final OpportunityRepository _repository;
  final SessionManager _sessionManager;
  CreateOpportunityUseCase(this._repository, this._sessionManager);

  Future<Opportunity> call({
    required String title,
    required String description,
    required String summary, 
    required String category,
    required List<String> requirements,
  }) async {final int managerId = _sessionManager.getManagerId() ?? 0;
    if (managerId == 0) {
      throw Exception("ID de manager no disponible. Por favor, vuelva a iniciar sesión.");
    }
    final createDto = CreateOpportunityDto(
      companyId: managerId,
      title: title,
      description: description,
      summary: summary, 
      category: category,
      requirements: requirements,
    );
    return await _repository.createOpportunity(createDto);
  }
}