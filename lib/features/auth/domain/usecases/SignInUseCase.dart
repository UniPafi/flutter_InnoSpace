import '../models/user.dart';
import '../repositories/auth_repository.dart';


class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<User> call({required String email, required String password}) async {
    
    return await _repository.signIn(email: email, password: password);
  }
}