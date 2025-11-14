import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/domain/models/user.dart';
import 'package:flutter_innospace/features/auth/domain/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    // ---
    // AÑADIR ESTE MANEJADOR
    // ---
    on<LoginReset>(_onReset);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    // ---
    // AÑADE ESTA LÍNEA PARA LIMPIAR ERRORES ANTERIORES
    // ---
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    try {
      final user = await _authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: Status.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  // ---
  // AÑADIR ESTA NUEVA FUNCIÓN
  // ---
  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    // Emite un estado completamente nuevo y limpio
    emit(const LoginState());
  }
}