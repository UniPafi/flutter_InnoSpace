import 'package:flutter_innospace/features/postulations/domain/models/postulation_card.dart';
import 'package:flutter_innospace/features/postulations/domain/repositories/postulations_repository.dart';

class GetPostulationsUseCase {
  final PostulationsRepository repository;

  GetPostulationsUseCase(this.repository);

  Future<List<PostulationCard>> execute(int managerId) {
    return repository.getPostulations(managerId);
  }
}
