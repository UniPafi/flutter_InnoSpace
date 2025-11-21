import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/core/utils/image_utils.dart';
import 'package:flutter_innospace/features/explore/domain/models/student_profile.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_state.dart';

class ProjectDetailPage extends StatelessWidget {
  final int projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    context.read<ProjectDetailBloc>().add(FetchProjectDetail(projectId));

    return Scaffold(
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
                
                
                
                
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 12),

                
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    Chip(label: Text('Categoría: ${project.category}')),
                    
                  ],
                ),
                const SizedBox(height: 16),

                // Resumen
                _buildSectionTitle(context, 'Resumen'),
                const SizedBox(height: 8),
                Text(project.summary),
                const SizedBox(height: 24),

        
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
    );
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

        
        _buildSectionTitle(context, 'Biografía'),
        const SizedBox(height: 8),
        Text(profile.description),
        const SizedBox(height: 20),

        
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

      
        _buildSectionTitle(context, 'Habilidades'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: profile.skills.map((skill) => Chip(label: Text(skill))).toList(),
        ),
        const SizedBox(height: 20),
     
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

}