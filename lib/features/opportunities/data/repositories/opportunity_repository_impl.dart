import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/data/services/opportunity_service.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';
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

  // --- Nuevos métodos implementados ---

  @override
  Future<List<StudentApplication>> getStudentApplications(int opportunityId) async {
    final token = _getToken();

    // 1. Obtenemos la lista básica de postulantes (Cards)
    final applicationsDtos = await _service.getStudentApplications(token, opportunityId);

    // 2. Creamos una lista de futuros para obtener los perfiles detallados en paralelo
    //    Esto evita llamar uno por uno secuencialmente, mejorando el rendimiento.
    final futureDetails = applicationsDtos.map((appDto) async {
      try {
        // Llamamos al endpoint de detalles de perfil usando el studentId
        final profileDto = await _service.getStudentProfile(token, appDto.studentId);
        
        // Combinamos la info básica de la card con la detallada del perfil
        return appDto.toDomainWithProfile(profileDto);
      } catch (e) {
        // Si falla la carga del detalle (ej. error de red puntual o 404), 
        // devolvemos la data básica para que al menos se vea la card en la lista
        print("Error obteniendo perfil para studentId ${appDto.studentId}: $e");
        return appDto.toDomain();
      }
    });

    // 3. Esperamos a que todas las consultas paralelas terminen y retornamos la lista completa
    return await Future.wait(futureDetails);
  }

  @override
  Future<void> acceptStudentApplication(int applicationId) async {
    await _service.acceptStudentApplication(_getToken(), applicationId);
  }

  @override
  Future<void> rejectStudentApplication(int applicationId) async {
    await _service.rejectStudentApplication(_getToken(), applicationId);
  }
}