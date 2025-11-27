import 'dart:convert';
import 'package:flutter_innospace/core/constants/api_constants.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/postulations/data/models/postulation_card_dto.dart';
import 'package:http/http.dart' as http;

class PostulationsService {
  final http.Client _client;
  final SessionManager _sessionManager;

  PostulationsService(this._client, this._sessionManager);

  Future<List<PostulationCardDto>> getPostulationsByManager(int managerId) async {
    final String? token = _sessionManager.getAuthToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/collaboration-cards/managers/$managerId');

    final response = await _client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => PostulationCardDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Failed to load postulations: 401');
    } else {
      throw Exception('Failed to load postulations: ${response.statusCode} ${response.body}');
    }
  }
}