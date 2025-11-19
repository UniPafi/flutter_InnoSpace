import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_bloc.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_event.dart';
import 'package:flutter_innospace/features/explore/presentation/blocs/explore_projects/explore_projects_state.dart';
import 'package:flutter_innospace/features/explore/presentation/widgets/project_card.dart';

class ExploreProjectList extends StatelessWidget {
  final bool isFavoriteView; 

  const ExploreProjectList({super.key, required this.isFavoriteView});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      buildWhen: (previous, current) => 
          previous.status != current.status || previous.projects != current.projects,
      builder: (context, state) {
        
        if (state.status == Status.loading && state.projects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

      
        if (state.status == Status.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar la lista: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExploreBloc>().add(FetchProjects(isFavoriteView: isFavoriteView));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        
        final projectsToShow = state.projects;

        if (projectsToShow.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                isFavoriteView
                    ? 'Aún no has guardado proyectos como favoritos. ¡Explora para encontrar algunos!'
                    : 'No se encontraron proyectos publicados en este momento.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<ExploreBloc>().add(FetchProjects(isFavoriteView: isFavoriteView));
           
            await context.read<ExploreBloc>().stream.firstWhere((s) => s.status != Status.loading);
          },
          child: ListView.builder(
            itemCount: projectsToShow.length,
            itemBuilder: (context, index) {
              final project = projectsToShow[index];
              return ProjectCard(project: project); 
            },
          ),
        );
      },
    );
  }
}