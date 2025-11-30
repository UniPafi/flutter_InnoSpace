import 'dart:convert';

import 'package:flutter_innospace/core/constants/api_constants.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:http/http.dart' as http;

class CollaborationService {
  final http.Client _client;
  final SessionManager _sessionManager;

  CollaborationService(this._client, this._sessionManager);

  Future<void> sendRequest(int projectId) async {
    final String? token = _sessionManager.getAuthToken();
    final int? managerId = _sessionManager.getManagerId(); 

    if (token == null || managerId == null) {
      throw Exception('Manager no autenticado o ID de manager no disponible.');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/collaborations');
    
    final body = jsonEncode({
      "projectId": projectId,
      "managerId": managerId, 
    });

    final response = await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) { 
      throw Exception('Fallo al enviar la solicitud de colaboración: ${response.body}');
    }
  }
}