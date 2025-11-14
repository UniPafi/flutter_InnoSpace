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
    try {
      // 1. Iniciar sesión (ahora con el servicio http)
      final UserDto userDto = await _authService.signIn(email, password);

      // 2. Obtener TODOS los perfiles de manager (con el token del DTO)
      final List<ManagerProfileDto> allProfiles = 
          await _authService.getAllManagerProfiles(userDto.token);

      // 3. Encontrar nuestro perfil de manager usando el userId
      final ManagerProfileDto myProfile = allProfiles.firstWhere(
        (profile) => profile.userId == userDto.id,
        orElse: () => throw Exception("No se encontró el perfil de manager para este usuario."),
      );

      // 4. Guardar toda la información en la sesión
      await _sessionManager.saveSession(
        token: userDto.token,
        userId: userDto.id,
        managerId: myProfile.id, // ¡El managerId!
      );

      // 5. Devolver el modelo de dominio
      // (Pasamos el managerId al método toDomain)
      return userDto.toDomain(myProfile.id);
      
    } catch (e) {
      throw Exception("Error en el repositorio: ${e.toString()}");
    }
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signUp(name, email, password);
    } catch (e) {
      throw Exception("Error en el repositorio: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    await _sessionManager.clearSession();
  }
}