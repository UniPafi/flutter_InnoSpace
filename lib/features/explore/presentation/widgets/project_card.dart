import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_project_detail_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_student_profile_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/send_collaboration_request_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/pages/project_detail_page.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF673AB7);
    const Color accentPurple = Color(0xFF8E6CEF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Franja lateral morada (Diseño de la imagen)
              Container(
                width: 6,
                color: accentPurple,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<ProjectDetailBloc>(
                          create: (context) => ProjectDetailBloc(
                            context.read<GetProjectDetailUseCase>(),
                            context.read<GetStudentProfileUseCase>(),
                            context.read<SendCollaborationRequestUseCase>(),
                          ),
                          child: ProjectDetailPage(projectId: project.id),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabecera: Título y Favorito
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Nombre de la empresa o subtexto (placeholder si no hay en modelo)
                                  const Text(
                                    "Empresa / Organización", 
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botón Favorito
                            InkWell(
                              onTap: () {
                                context
                                    .read<ExploreBloc>()
                                    .add(ToggleFavoriteProject(project.id));
                                // Refrescar si estamos en vista favoritos
                                final currentTab = DefaultTabController.of(context)?.index ?? 0;
                                if (currentTab == 1) {
                                   context.read<ExploreBloc>().add(const FetchProjects(isFavoriteView: true));
                                }
                              },
                              child: Icon(
                                project.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: project.isFavorite
                                    ? Colors.redAccent
                                    : Colors.grey[400],
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Chip de Categoría
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            project.category.toUpperCase(),
                            style: const TextStyle(
                              color: primaryPurple,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Descripción / Resumen
                        Text(
                          project.summary,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}