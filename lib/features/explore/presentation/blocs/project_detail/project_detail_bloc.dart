import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_project_detail_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final GetProjectDetailUseCase _getProjectDetailUseCase;

  ProjectDetailBloc(this._getProjectDetailUseCase) : super(const ProjectDetailState()) {
    on<FetchProjectDetail>(_onFetchProjectDetail);
  }

  Future<void> _onFetchProjectDetail(
    FetchProjectDetail event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final project = await _getProjectDetailUseCase.call(event.projectId);
      emit(state.copyWith(
        status: Status.success,
        project: project,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}

