import '../models/user.dart';
abstract class AuthRepository {
  Future<User> signIn({required String email, required String password});
  
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

   
}