import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_project_detail_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_student_profile_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/send_collaboration_request_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final GetProjectDetailUseCase _getProjectDetailUseCase;
  final GetStudentProfileUseCase _getStudentProfileUseCase; 
final SendCollaborationRequestUseCase _sendCollaborationRequestUseCase; 

  ProjectDetailBloc(
    this._getProjectDetailUseCase,
     this._getStudentProfileUseCase,
     this._sendCollaborationRequestUseCase,) 
      : super(const ProjectDetailState()) {
    on<FetchProjectDetail>(_onFetchProjectDetail);
    on<SendCollaborationRequest>(_onSendCollaborationRequest); 
  }

  Future<void> _onFetchProjectDetail(
    FetchProjectDetail event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final baseProject = await _getProjectDetailUseCase.call(event.projectId);
      
      final profileId = baseProject.studentId;
      
      StudentProfile? profile;
      if (profileId != null && profileId > 0) {
        profile = await _getStudentProfileUseCase.call(profileId);
      }
      
      final finalProject = baseProject.copyWith(studentProfile: profile);
      
      emit(state.copyWith(
        status: Status.success,
        project: finalProject,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

Future<void> _onSendCollaborationRequest(
    SendCollaborationRequest event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(state.copyWith(requestStatus: Status.loading, requestError: null));
    
    try {
      await _sendCollaborationRequestUseCase.call(event.projectId);
      
      emit(state.copyWith(requestStatus: Status.success));
      
    } catch (e) {
      emit(state.copyWith(requestStatus: Status.error, requestError: e.toString()));
    }
  }


}