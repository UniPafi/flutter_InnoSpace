import 'package:flutter_innospace/features/postulations/domain/models/postulation_card.dart';

abstract class PostulationsState {}

class PostulationsInitial extends PostulationsState {}

class PostulationsLoading extends PostulationsState {}

class PostulationsLoaded extends PostulationsState {
  final List<PostulationCard> postulations;

  PostulationsLoaded(this.postulations);
}

class PostulationsError extends PostulationsState {
  final String message;

  PostulationsError(this.message);
}
