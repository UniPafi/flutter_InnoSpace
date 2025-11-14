import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String token;
  final int managerId;

  const User({
    required this.id,
    required this.email,
    required this.token,
    required this.managerId,
  });

  @override
  List<Object?> get props => [id, email, token, managerId];
}