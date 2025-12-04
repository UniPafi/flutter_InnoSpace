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
    const Color headerColor = Color(0xFF7E57C2);
    const Color backgroundColor = Color(0xFFEDE7F6);

    return BlocProvider(
      create: (context) => StudentApplicationsBloc(
        context.read<GetStudentApplicationsUseCase>(),
        context.read<AcceptStudentApplicationUseCase>(),
        context.read<RejectStudentApplicationUseCase>(),
      )..add(FetchStudentApplications(opportunityId)),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Postulantes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: headerColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: BlocBuilder<StudentApplicationsBloc, StudentApplicationsState>(
          builder: (context, state) {
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
                padding: const EdgeInsets.symmetric(vertical: 20),
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