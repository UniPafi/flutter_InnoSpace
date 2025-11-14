import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';
import '../blocs/create_opportunity/create_opportunity_bloc.dart';

class CreateOpportunityPage extends StatelessWidget {
  const CreateOpportunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateOpportunityBloc(
        context.read<OpportunityRepository>(),
        context.read<SessionManager>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Nueva Convocatoria'),
        ),
        body: BlocConsumer<CreateOpportunityBloc, CreateOpportunityState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              // Muestra diálogo y regresa
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Éxito'),
                  content: const Text('La convocatoria se ha creado como borrador.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra diálogo
                        Navigator.of(context).pop(true); // Regresa (pasando true para recargar)
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
            if (state.status == Status.error) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(TitleChanged(value)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Resumen (Summary)'), // <-- CORREGIDO LABEL
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(SummaryChanged(value)), // <-- CORREGIDO EVENTO
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLines: 5,
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(DescriptionChanged(value)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(CategoryChanged(value)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Requisitos',
                      hintText: 'Separados por comas (ej. Dart, Flutter, Firebase)',
                    ),
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(RequirementsChanged(value)),
                  ),
                  const SizedBox(height: 32),
                  if (state.status == Status.loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () => context.read<CreateOpportunityBloc>().add(FormSubmitted()),
                      child: const Text('Guardar Borrador'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}