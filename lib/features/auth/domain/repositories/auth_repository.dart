import '../models/user.dart';
import '../models/manager_profile.dart';
abstract class AuthRepository {
  Future<User> signIn({required String email, required String password});
  
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

   Future<List<ManagerProfile>> getManagerProfiles(String token);
}