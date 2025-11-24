part of 'student_applications_bloc.dart';

abstract class StudentApplicationsEvent extends Equatable {
  const StudentApplicationsEvent();
  @override
  List<Object> get props => [];
}

class FetchStudentApplications extends StudentApplicationsEvent {
  final int opportunityId;
  const FetchStudentApplications(this.opportunityId);
}

class AcceptApplication extends StudentApplicationsEvent {
  final int applicationId;
  final int opportunityId; // Para recargar la lista
  const AcceptApplication({required this.applicationId, required this.opportunityId});
}

class RejectApplication extends StudentApplicationsEvent {
  final int applicationId;
  final int opportunityId; // Para recargar la lista
  const RejectApplication({required this.applicationId, required this.opportunityId});
}