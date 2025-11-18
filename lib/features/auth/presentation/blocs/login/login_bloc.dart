import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/auth/domain/models/user.dart';
import 'package:flutter_innospace/features/auth/domain/usecases/SignInUseCase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInUseCase _signInUseCase; 

  LoginBloc(this._signInUseCase) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginReset>(_onReset);
  }
  
 

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));
    try {
    
      final user = await _signInUseCase.call( // <-- Llamada al Use Case
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: Status.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    
    emit(const LoginState());
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, errorMessage: null));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password, errorMessage: null));
  }
}