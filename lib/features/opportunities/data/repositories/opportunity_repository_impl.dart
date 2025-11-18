import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/data/services/opportunity_service.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

class OpportunityRepositoryImpl implements OpportunityRepository {
  final OpportunityService _service;
  final SessionManager _sessionManager;

  OpportunityRepositoryImpl(this._service, this._sessionManager);

  String _getToken() => _sessionManager.getAuthToken() ?? '';
  int _getManagerId() => _sessionManager.getManagerId() ?? 0;

  @override
  Future<Opportunity> createOpportunity(CreateOpportunityDto createDto) async {
    final dto = await _service.createOpportunity(_getToken(), createDto);
    return dto.toDomain();
  }

  @override
  Future<List<Opportunity>> getMyOpportunities() async {
    final int managerId = _getManagerId();
    if (managerId == 0) throw Exception("Manager ID no encontrado");

    final dtos = await _service.getOpportunities(_getToken(), managerId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Opportunity> getOpportunityById(int id) async {
    final dto = await _service.getOpportunityById(_getToken(), id);
    return dto.toDomain();
  }

  @override
  Future<Opportunity> publishOpportunity(int id) async {
    final dto = await _service.publishOpportunity(_getToken(), id);
    return dto.toDomain();
  }

  @override
  Future<Opportunity> closeOpportunity(int id) async {
    final dto = await _service.closeOpportunity(_getToken(), id);
    return dto.toDomain();
  }

  @override
  Future<void> deleteOpportunity(int id) async {
    await _service.deleteOpportunity(_getToken(), id);
  }
}