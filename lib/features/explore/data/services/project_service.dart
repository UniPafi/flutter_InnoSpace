import 'dart:convert';

import 'package:flutter_innospace/core/constants/api_constants.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/explore/data/models/project_dto.dart';
import 'package:http/http.dart' as http;

class ProjectService {
  final http.Client _client;
  final SessionManager _sessionManager;

  ProjectService(this._client, this._sessionManager);

  Future<List<ProjectDto>> getAllProjects() async {
    final String? token = _sessionManager.getAuthToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/projects'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ProjectDto.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Fallo al cargar proyectos: ${response.statusCode}');
    }
  }
}