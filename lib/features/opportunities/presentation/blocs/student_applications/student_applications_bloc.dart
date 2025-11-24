import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_student_applications_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/accept_student_application_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/reject_student_application_use_case.dart';


part 'student_applications_event.dart';
part 'student_applications_state.dart';

class StudentApplicationsBloc extends Bloc<StudentApplicationsEvent, StudentApplicationsState> {
  final GetStudentApplicationsUseCase _getStudentApplicationsUseCase;
  final AcceptStudentApplicationUseCase _acceptUseCase; // Nuevo
  final RejectStudentApplicationUseCase _rejectUseCase; // Nuevo


  StudentApplicationsBloc(
    this._getStudentApplicationsUseCase,
    this._acceptUseCase,
    this._rejectUseCase,
  ) : super(const StudentApplicationsState()) {
    on<FetchStudentApplications>(_onFetchApplications);
    on<AcceptApplication>(_onAcceptApplication);
    on<RejectApplication>(_onRejectApplication);
  }

  Future<void> _onFetchApplications(
    FetchStudentApplications event,
    Emitter<StudentApplicationsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final applications = await _getStudentApplicationsUseCase.call(opportunityId: event.opportunityId);
      emit(state.copyWith(
        status: Status.success,
        applications: applications,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onAcceptApplication(
    AcceptApplication event,
    Emitter<StudentApplicationsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _acceptUseCase.call(applicationId: event.applicationId);
      // Recargamos la lista para ver el cambio de estado
      add(FetchStudentApplications(event.opportunityId)); 
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onRejectApplication(
    RejectApplication event,
    Emitter<StudentApplicationsState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _rejectUseCase.call(applicationId: event.applicationId);
      // Recargamos la lista para ver el cambio de estado
      add(FetchStudentApplications(event.opportunityId));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}