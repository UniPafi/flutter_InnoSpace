import 'package:flutter_innospace/features/postulations/domain/models/postulation_card.dart';

abstract class PostulationsRepository {
  Future<List<PostulationCard>> getPostulations(int managerId);
}
