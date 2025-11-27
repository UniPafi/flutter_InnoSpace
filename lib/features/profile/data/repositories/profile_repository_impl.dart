import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/auth/domain/models/manager_profile.dart';
import 'package:flutter_innospace/features/profile/data/services/profile_service.dart';
import 'package:flutter_innospace/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _service;
  final SessionManager _sessionManager;

  ProfileRepositoryImpl(this._service, this._sessionManager);

  @override
  Future<ManagerProfile> getManagerProfile(int managerId) async {
    final dto = await _service.getManagerProfile(managerId);

    // Convertir DTO a Model
    return ManagerProfile(
      id: dto.id,
      userId: dto.userId,
      name: dto.name,
      photoUrl: dto.photoUrl,
      description: dto.description,
      phoneNumber: dto.phoneNumber,
      companyName: dto.companyName,
      focusArea: dto.focusArea,
      location: dto.location,
      companyTechnologies: dto.companyTechnologies,
    );
  }

  @override
  Future<ManagerProfile> updateManagerProfile(
      int managerId, ManagerProfile profile) async {
    final profileData = {
      'name': profile.name,
      'photoUrl': profile.photoUrl,
      'description': profile.description,
      'phoneNumber': profile.phoneNumber,
      'companyName': profile.companyName,
      'focusArea': profile.focusArea,
      'location': profile.location,
      'companyTechnologies': profile.companyTechnologies,
    };

    final dto = await _service.updateManagerProfile(managerId, profileData);

    return ManagerProfile(
      id: dto.id,
      userId: dto.userId,
      name: dto.name,
      photoUrl: dto.photoUrl,
      description: dto.description,
      phoneNumber: dto.phoneNumber,
      companyName: dto.companyName,
      focusArea: dto.focusArea,
      location: dto.location,
      companyTechnologies: dto.companyTechnologies,
    );
  }
}
