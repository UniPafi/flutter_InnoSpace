import 'package:flutter_innospace/features/auth/domain/models/user.dart';

class UserDto {
  final int id; // userId
  final String email;
  final String token;

  const UserDto({
    required this.id,
    required this.email,
    required this.token,
  });

  // Fábrica manual
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  // Método para convertir a modelo de Dominio
  // (Le pasamos el managerId que obtendremos por separado)
  User toDomain(int managerId) {
    return User(
      id: id,
      email: email,
      token: token,
      managerId: managerId,
    );
  }
}