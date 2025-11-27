import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/postulations/domain/uses-cases/get_postulations.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_event.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_state.dart';

class PostulationsBloc extends Bloc<PostulationsEvent, PostulationsState> {
  final GetPostulationsUseCase getPostulationsUseCase;

  PostulationsBloc(this.getPostulationsUseCase) : super(PostulationsInitial()) {
    on<LoadPostulationsEvent>(_onLoadPostulations);
  }

  Future<void> _onLoadPostulations(
    LoadPostulationsEvent event,
    Emitter<PostulationsState> emit,
  ) async {
    try {
      emit(PostulationsLoading());

      final result = await getPostulationsUseCase.execute(event.managerId);

      emit(PostulationsLoaded(result));
    } catch (e) {
      emit(PostulationsError(e.toString()));
    }
  }
}
