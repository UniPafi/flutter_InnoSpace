import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_innospace/core/constants/api_constants.dart';
import 'package:flutter_innospace/features/auth/data/models/manager_profile_dto.dart';

class ProfileService {
  final http.Client _client;

  ProfileService(this._client);

  Future<ManagerProfileDto> getManagerProfile(
      int managerId, String token) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.managerProfiles}/$managerId');

    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ManagerProfileDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener el perfil: ${response.body}');
    }
  }

  Future<ManagerProfileDto> updateManagerProfile(
    int managerId,
    String token,
    Map<String, dynamic> profileData,
  ) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.managerProfiles}/$managerId');

    final response = await _client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      return ManagerProfileDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }
}
