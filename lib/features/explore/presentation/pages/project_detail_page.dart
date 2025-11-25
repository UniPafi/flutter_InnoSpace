import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/core/utils/image_utils.dart';
import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_state.dart';
class ProjectDetailPage extends StatefulWidget {
  final int projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  
  Widget _buildCollaborationButton(BuildContext context, ProjectDetailState state) {
    if (state.project == null || state.status == Status.loading) {
        return const SizedBox.shrink(); 
    }

    
    final isSending = state.requestStatus == Status.loading;
    final isSent = state.requestStatus == Status.success;

    if (isSent) {
      return const ElevatedButton(
        onPressed: null, 
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.green),
        ),
        child: Text('✅ Solicitud Enviada', style: TextStyle(color: Colors.white)),
      );
    }
    
    return ElevatedButton.icon(
      icon: isSending
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.send),
      label: Text(isSending ? 'Enviando...' : 'Enviar Solicitud de Colaboración'),
      onPressed: isSending
          ? null
          : () {
              context.read<ProjectDetailBloc>().add(
                    SendCollaborationRequest(widget.projectId),
                  );
            },
    );
  }

  void _showSnackbar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    if (isError) {
      context.read<ProjectDetailBloc>().add(ResetCollaborationRequestStatus());
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }


  Widget _buildStudentProfile(BuildContext context, StudentProfile? profile) {

    if (profile == null) {
      return const Center(
          child: Text('No hay información de perfil disponible.', style: TextStyle(fontStyle: FontStyle.italic)));
    }

    final profileImageBytes = decodeBase64Image(profile.photoUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Perfil del Estudiante'),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              backgroundImage: profileImageBytes != null
                  ? MemoryImage(profileImageBytes)
                  : null,
              child: profileImageBytes == null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Biografía
        _buildSectionTitle(context, 'Biografía'),
        const SizedBox(height: 8),
        Text(profile.description),
        const SizedBox(height: 20),
        // Contacto y Portfolio
        _buildSectionTitle(context, 'Contacto'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.phone, color: Colors.grey),
          title: Text(profile.phoneNumber),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.link, color: Colors.grey),
          title: Text(profile.portfolioUrl),
        ),
        const SizedBox(height: 20),
        // Habilidades
        _buildSectionTitle(context, 'Habilidades'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: profile.skills.map((skill) => Chip(label: Text(skill))).toList(),
        ),
        const SizedBox(height: 20),
        // Experiencia
        _buildSectionTitle(context, 'Experiencia'),
        const SizedBox(height: 8),
        if (profile.experiences.isEmpty) 
          const Text('No hay experiencia listada.'),
        ...profile.experiences.map((exp) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text('• $exp'),
        )).toList(),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    context.read<ProjectDetailBloc>().add(FetchProjectDetail(widget.projectId));

    return BlocListener<ProjectDetailBloc, ProjectDetailState>(
      listener: (context, state) {
        if (state.requestStatus == Status.success) {
          _showSnackbar(context, 'Solicitud de colaboración enviada con éxito.', isError: false);
        } else if (state.requestStatus == Status.error && state.requestError != null) {
          _showSnackbar(context, 'Fallo al enviar: ${state.requestError}', isError: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del Proyecto'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
          builder: (context, state) {
            
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == Status.error) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            final project = state.project;

            if (project == null) {
              return const Center(child: Text('Proyecto no encontrado.'));
            }


            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: _buildCollaborationButton(context, state)),
                  const SizedBox(height: 20),
                  
                  // 2. Título
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 12),

                  // 3. Categoría y Estado
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Chip(label: Text('Categoría: ${project.category}')),
                      Chip(label: Text('Estado: ${project.status}')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Resumen
                  _buildSectionTitle(context, 'Resumen'),
                  const SizedBox(height: 8),
                  Text(project.summary),
                  const SizedBox(height: 24),

                  // 5. Descripción Completa
                  _buildSectionTitle(context, 'Descripción Completa'),
                  const SizedBox(height: 8),
                  Text(project.description),
                  const Divider(height: 40),

                  _buildStudentProfile(context, project.studentProfile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}