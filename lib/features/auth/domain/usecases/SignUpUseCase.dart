
import '../repositories/auth_repository.dart';
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _repository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}