import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/explore/domain/models/project.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_project_detail_use_case.dart';
import 'package:flutter_innospace/features/explore/domain/use_cases/get_student_profile_use_case.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/project_detail/project_detail_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/pages/project_detail_page.dart';


class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
child: InkWell( // Usamos InkWell para dar feedback visual al usuario al hacer clic
        onTap: () {
          // 1. Navegamos a la nueva ruta
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider<ProjectDetailBloc>(
                // 2. Creamos el BLoC de detalle de proyecto e inyectamos sus Use Cases
                create: (context) => ProjectDetailBloc(
                  context.read<GetProjectDetailUseCase>(),
                  context.read<GetStudentProfileUseCase>(),
                ),
                // 3. Pasamos el ID del proyecto a la página de detalle
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
            // Título
            Text(
              project.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor, // Morado
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                project.category,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              project.summary,
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  project.isFavorite ? Icons.favorite : Icons.favorite_border,
                  // ignore: deprecated_member_use
                  color: project.isFavorite ? Colors.redAccent : theme.colorScheme.onSurface.withOpacity(0.5),
                  size: 28,
                ),
                onPressed: () {
                  context.read<ExploreBloc>().add(ToggleFavoriteProject(project.id));
                  
                
                  final currentTab = DefaultTabController.of(context)?.index ?? 0;
                  final isFavView = currentTab == 1;
                  context.read<ExploreBloc>().add(FetchProjects(isFavoriteView: isFavView));
                },
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}