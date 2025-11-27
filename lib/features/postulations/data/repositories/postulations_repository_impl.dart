import '../../domain/models/postulation_card.dart';
import '../../domain/repositories/postulations_repository.dart';
import '../models/postulation_card_dto.dart';
import '../services/postulations_service.dart';

class PostulationsRepositoryImpl implements PostulationsRepository {
  final PostulationsService service;

  PostulationsRepositoryImpl(this.service);

  @override
  Future<List<PostulationCard>> getPostulations(int managerId) async {
    final dtos = await service.getPostulationsByManager(managerId);
    return dtos.map(_mapDtoToEntity).toList();
  }

  PostulationCard _mapDtoToEntity(PostulationCardDto dto) {
    return PostulationCard(
      collaborationId: dto.collaborationId,
      projectId: dto.projectId,
      projectTitle: dto.projectTitle,
      projectDescription: dto.projectDescription,
      managerId: dto.managerId,
      managerName: dto.managerName,
      companyName: dto.companyName,
      managerPhotoUrl: dto.managerPhotoUrl,
      studentResponse: dto.studentResponse,
    );
  }
}
