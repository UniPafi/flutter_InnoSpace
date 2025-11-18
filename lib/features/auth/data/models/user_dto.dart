import 'package:flutter_innospace/features/auth/domain/models/user.dart';

class UserDto {
  final int id; 
  final String email;
  final String token;

  const UserDto({
    required this.id,
    required this.email,
    required this.token,
  });

  
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

User toDomain(int managerId) {
  return User(
    id: id,
    email: email,
    token: token,
    managerId: managerId, // Aceptable porque el Repositorio sabe quién es el Manager
  );
}
}