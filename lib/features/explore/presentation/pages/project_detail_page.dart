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
  // Colores del diseño
  static const Color primaryPurple = Color(0xFF673AB7);
  static const Color lightGrayBg = Color(0xFFF5F5F5);

  Widget _buildCollaborationButton(
      BuildContext context, ProjectDetailState state) {
    if (state.project == null || state.status == Status.loading) {
      return const SizedBox.shrink();
    }

    final isSending = state.requestStatus == Status.loading;
    final isSent = state.requestStatus == Status.success;

    if (isSent) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green,
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text('Solicitud Enviada',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      );
    }

    return ElevatedButton.icon(
      icon: isSending
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.send_rounded, size: 24),
      label: Text(
        isSending ? 'Enviando...' : 'Enviar Solicitud de Colaboración',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      onPressed: isSending
          ? null
          : () {
              context.read<ProjectDetailBloc>().add(
                    SendCollaborationRequest(widget.projectId),
                  );
            },
    );
  }

  void _showSnackbar(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
    if (isError) {
      context.read<ProjectDetailBloc>().add(ResetCollaborationRequestStatus());
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryPurple,
      ),
    );
  }

  Widget _buildStudentProfile(BuildContext context, StudentProfile? profile) {
    if (profile == null) {
      return const Center(
          child: Text('No hay información de perfil disponible.',
              style: TextStyle(fontStyle: FontStyle.italic)));
    }

    final profileImageBytes = decodeBase64Image(profile.photoUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Perfil del Estudiante'),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryPurple, width: 2),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes)
                    : null,
                child: profileImageBytes == null
                    ? const Icon(Icons.person, size: 35, color: primaryPurple)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Biografía
        if (profile.description.isNotEmpty) ...[
          const Text("Biografía",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            profile.description,
            style: TextStyle(color: Colors.grey[700], height: 1.4),
          ),
          const SizedBox(height: 16),
        ],

        // Contacto
        if (profile.phoneNumber.isNotEmpty || profile.portfolioUrl.isNotEmpty) ...[
          const Text("Contacto",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          if (profile.phoneNumber.isNotEmpty)
            Row(children: [
              Icon(Icons.phone, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(profile.phoneNumber,
                  style: TextStyle(color: Colors.grey[700])),
            ]),
          if (profile.portfolioUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(children: [
                Icon(Icons.link, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(profile.portfolioUrl,
                      style: const TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          const SizedBox(height: 16),
        ],

        // Habilidades
        if (profile.skills.isNotEmpty) ...[
          const Text("Habilidades",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: profile.skills
                .map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: primaryPurple.withOpacity(0.05),
                      labelStyle: TextStyle(
                          color: primaryPurple.withOpacity(0.8), fontSize: 12),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ProjectDetailBloc>()
        .add(FetchProjectDetail(widget.projectId));

    return BlocListener<ProjectDetailBloc, ProjectDetailState>(
      listener: (context, state) {
        if (state.requestStatus == Status.success) {
          _showSnackbar(context, 'Solicitud enviada con éxito.',
              isError: false);
        } else if (state.requestStatus == Status.error &&
            state.requestError != null) {
          _showSnackbar(context, 'Fallo al enviar: ${state.requestError}',
              isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: lightGrayBg,
        appBar: AppBar(
          title: const Text('Detalle del Proyecto',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
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

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 100),
                  child: Column(
                    children: [
                      // Tarjeta del Proyecto
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryPurple),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    project.category,
                                    style: const TextStyle(
                                        color: primaryPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    project.status.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSectionTitle('Resumen'),
                            const SizedBox(height: 8),
                            Text(
                              project.summary,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87.withOpacity(0.7)),
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Descripción Completa'),
                            const SizedBox(height: 8),
                            Text(
                              project.description,
                              style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tarjeta del Estudiante
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildStudentProfile(
                            context, project.studentProfile),
                      ),
                    ],
                  ),
                ),
                // Botón Flotante Inferior
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                        child: _buildCollaborationButton(context, state)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}