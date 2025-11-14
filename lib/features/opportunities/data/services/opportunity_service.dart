import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_innospace/core/constants/api_constants.dart';
import '../models/create_opportunity_dto.dart';
import '../models/opportunity_dto.dart';

class OpportunityService {
  final http.Client _client;

  OpportunityService(this._client);

  final String _baseUrl = ApiConstants.baseUrl;

  // GET /api/v1/opportunities/company/{companyId}
  Future<List<OpportunityDto>> getOpportunities(String token, int managerId) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunitiesByCompany}/$managerId");
    
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => OpportunityDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar convocatorias (Código: ${response.statusCode}): ${response.body}');
    }
  }

  // GET /api/v1/opportunities/{id}
  Future<OpportunityDto> getOpportunityById(String token, int opportunityId) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunities}/$opportunityId");
    
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return OpportunityDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al cargar detalle (Código: ${response.statusCode}): ${response.body}');
    }
  }

  // POST /api/v1/opportunities
  Future<OpportunityDto> createOpportunity(String token, CreateOpportunityDto dto) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunities}");
    
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: dto.toJsonString(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return OpportunityDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al crear convocatoria (Código: ${response.statusCode}): ${response.body}');
    }
  }

  // POST /api/v1/opportunities/{id}/publish
  Future<OpportunityDto> publishOpportunity(String token, int opportunityId) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunities}/$opportunityId${ApiConstants.publishOpportunity}");
    
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return OpportunityDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al publicar (Código: ${response.statusCode}): ${response.body}');
    }
  }

  // POST /api/v1/opportunities/{id}/close
  Future<OpportunityDto> closeOpportunity(String token, int opportunityId) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunities}/$opportunityId${ApiConstants.closeOpportunity}");
    
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return OpportunityDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al cerrar (Código: ${response.statusCode}): ${response.body}');
    }
  }

  // ---
  // ¡CORRECCIÓN AQUÍ!
  // ---
  // DELETE /api/v1/opportunities/{id}
  Future<void> deleteOpportunity(String token, int opportunityId) async {
    final uri = Uri.parse("$_baseUrl${ApiConstants.opportunities}/$opportunityId");
    
    final response = await _client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Aceptamos 200 (OK) y 204 (No Content) como éxito.
    if (response.statusCode == 200 || response.statusCode == 204) {
      return; // Éxito
    } else {
      // Mostramos un error más detallado si falla
      throw Exception('Error al eliminar convocatoria (Código: ${response.statusCode}): ${response.body}');
    }
  }
}