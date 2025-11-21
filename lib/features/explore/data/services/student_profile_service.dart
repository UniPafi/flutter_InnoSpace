import 'dart:convert';

import 'package:flutter_innospace/core/constants/api_constants.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/explore/data/models/student_profile_dto.dart';
import 'package:http/http.dart' as http;

class StudentProfileService {
  final http.Client _client;
  final SessionManager _sessionManager;

  StudentProfileService(this._client, this._sessionManager);

  Future<StudentProfileDto> getStudentProfile(int profileId) async {
    final String? token = _sessionManager.getAuthToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/student-profiles/$profileId'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StudentProfileDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Fallo al cargar el perfil $profileId: ${response.statusCode}');
    }
  }
}