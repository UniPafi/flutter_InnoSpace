part of 'login_bloc.dart';

class LoginState extends Equatable {
  final Status status;
  final String email;
  final String password;
  final User? user;
  final String? errorMessage;

  const LoginState({
    this.status = Status.initial,
    this.email = '',
    this.password = '',
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    Status? status,
    String? email,
    String? password,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, password, user, errorMessage];
}