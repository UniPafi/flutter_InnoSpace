import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_innospace/core/constants/api_constants.dart';
import '../models/manager_profile_dto.dart';
import '../models/user_dto.dart';

class AuthService {
  final http.Client _client;
  
  
  final Uri _signInUri = Uri.parse(ApiConstants.baseUrl + ApiConstants.signIn);
  final Uri _signUpUri = Uri.parse(ApiConstants.baseUrl + ApiConstants.signUp);
  final Uri _managerProfilesUri = Uri.parse(ApiConstants.baseUrl + ApiConstants.managerProfiles);

  AuthService(this._client);

  Future<UserDto> signIn(String email, String password) async {
    final response = await _client.post(
      _signInUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
     
      return UserDto.fromJson(jsonDecode(response.body));
    } else {
      
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    final response = await _client.post(
      _signUpUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'accountType': 'MANAGER' 
      }),
    );

    if (response.statusCode != 201) { 
      throw Exception('Error al registrarse: ${response.body}');
    }
    
  }
  
  Future<List<ManagerProfileDto>> getAllManagerProfiles(String token) async {
    final response = await _client.get(
      _managerProfilesUri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
     
      return jsonList
          .map((json) => ManagerProfileDto.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al obtener perfiles de manager: ${response.body}');
    }
  }
}