import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/auth/data/services/auth_service.dart';
import 'package:flutter_innospace/features/auth/domain/models/user.dart';
import 'package:flutter_innospace/features/auth/domain/repositories/auth_repository.dart';
import '../models/manager_profile_dto.dart';
import '../models/user_dto.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final SessionManager _sessionManager;

  AuthRepositoryImpl(this._authService, this._sessionManager);

  @override
  Future<User> signIn({required String email, required String password}) async {

    
    final UserDto userDto = await _authService.signIn(email, password);

    final List<ManagerProfileDto> allProfiles = await _authService.getAllManagerProfiles(userDto.token);

    final ManagerProfileDto myProfile = allProfiles.firstWhere(
      (profile) => profile.userId == userDto.id,
      orElse: () => throw Exception("No se encontró el perfil de manager para este usuario."),
    );

    await _sessionManager.saveSession(
      token: userDto.token,
      userId: userDto.id,
      managerId: myProfile.id,
    );

    return userDto.toDomain(myProfile.id);
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _authService.signUp(name, email, password);
  }

  @override
  Future<void> signOut() async {
    await _sessionManager.clearSession();
  }
}