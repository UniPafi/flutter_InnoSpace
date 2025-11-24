part of 'student_applications_bloc.dart';

class StudentApplicationsState extends Equatable {
  final Status status;
  final List<StudentApplication> applications;
  final String? errorMessage;

  const StudentApplicationsState({
    this.status = Status.initial,
    this.applications = const [],
    this.errorMessage,
  });

  StudentApplicationsState copyWith({
    Status? status,
    List<StudentApplication>? applications,
    String? errorMessage,
  }) {
    return StudentApplicationsState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, applications, errorMessage];
}