import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_student_applications_use_case.dart';
import 'package:flutter_innospace/features/opportunities/presentation/blocs/student_applications/student_applications_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/widgets/student_application_card.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/accept_student_application_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/reject_student_application_use_case.dart';

class StudentApplicationsPage extends StatelessWidget {
  final int opportunityId;

  const StudentApplicationsPage({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentApplicationsBloc(
        context.read<GetStudentApplicationsUseCase>(),
        context.read<AcceptStudentApplicationUseCase>(), // Inyección
        context.read<RejectStudentApplicationUseCase>(), // Inyección
      )..add(FetchStudentApplications(opportunityId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Postulantes')),
        body: BlocBuilder<StudentApplicationsBloc, StudentApplicationsState>(
          builder: (context, state) {
            // ... casos de loading y error iguales ...
            if (state.status == Status.loading) {
               return const Center(child: CircularProgressIndicator());
            }
            if (state.status == Status.error) {
               return Center(child: Text('Error: ${state.errorMessage}'));
            }

            if (state.status == Status.success) {
              if (state.applications.isEmpty) {
                return const Center(child: Text('No hay postulantes aún.'));
              }
              return ListView.builder(
                itemCount: state.applications.length,
                itemBuilder: (context, index) {
                  final app = state.applications[index];
                  return StudentApplicationCard(
                    application: app,
                    onAccept: () {
                      context.read<StudentApplicationsBloc>().add(
                        AcceptApplication(
                          applicationId: app.id,
                          opportunityId: opportunityId,
                        ),
                      );
                    },
                    onReject: () {
                      context.read<StudentApplicationsBloc>().add(
                        RejectApplication(
                          applicationId: app.id,
                          opportunityId: opportunityId,
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}