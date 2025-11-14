import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id; // userId
  final String email;
  final String token;
  final int managerId; // El ID del perfil de manager

  const User({
    required this.id,
    required this.email,
    required this.token,
    required this.managerId,
  });

  @override
  List<Object?> get props => [id, email, token, managerId];
}