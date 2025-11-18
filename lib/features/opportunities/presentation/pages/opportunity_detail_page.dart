import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/CloseOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/DeleteOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/GetOpportunityByIdUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/PublishOpportunityUseCase.dart';
import '../blocs/opportunity_detail/opportunity_detail_bloc.dart';

class OpportunityDetailPage extends StatelessWidget {
  final int opportunityId;

  const OpportunityDetailPage({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpportunityDetailBloc>(
      create: (context) => OpportunityDetailBloc(
    context.read<GetOpportunityByIdUseCase>(),
    context.read<PublishOpportunityUseCase>(),
    context.read<CloseOpportunityUseCase>(),
    context.read<DeleteOpportunityUseCase>(),
  )..add(FetchOpportunityDetail(opportunityId)), 
  child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle Convocatoria'),
        ),
        body: BlocConsumer<OpportunityDetailBloc, OpportunityDetailState>(
          listener: (context, state) {
            if (state.status == Status.error) {
               ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ));
            }
            if (state.isDeleted) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Convocatoria eliminada'),
                  backgroundColor: Colors.green,
                ));
              Navigator.of(context).pop(true); 
            }
          },
          builder: (context, state) {
            if (state.status == Status.loading && state.opportunity == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.opportunity == null && state.status != Status.loading) {
              return const Center(child: Text('No se pudo cargar la convocatoria.'));
            }
            
            final opportunity = state.opportunity;
            if (opportunity == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: _buildContent(context, opportunity),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildActionButtons(context, opportunity),
                    ),
                  ],
                ),
                if (state.status == Status.loading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final bloc = context.read<OpportunityDetailBloc>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta convocatoria? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                bloc.add(DeleteOpportunity());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, Opportunity opportunity) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          Chip(
            label: Text(opportunity.category.isNotEmpty ? opportunity.category : "Sin Categoría"),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          const SizedBox(height: 16),
          
         
          Text(
            "Resumen: ${opportunity.summary}",
             style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            "Descripción Completa:",
             style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Requisitos:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (var req in opportunity.requirements)
            if (req.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Text('• $req'),
              ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Opportunity opportunity) {
    final bloc = context.read<OpportunityDetailBloc>();
    
    List<Widget> buttons = [];

    if (opportunity.status == OpportunityStatus.DRAFT) {
      buttons.add(
        ElevatedButton(
          onPressed: () => bloc.add(PublishOpportunity()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 40),
          ),
          child: const Text('Publicar Convocatoria'),
        ),
      );
    }

    if (opportunity.status == OpportunityStatus.PUBLISHED) {
      buttons.add(
        ElevatedButton(
          onPressed: () => bloc.add(CloseOpportunity()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 40),
          ),
          child: const Text('Cerrar Convocatoria'),
        ),
      );
    }
    
    if (opportunity.status == OpportunityStatus.CLOSED) {
      buttons.add(
        Center(
          child: Chip(
            label: const Text('Convocatoria Cerrada'),
            backgroundColor: Colors.grey[700],
            labelStyle: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (buttons.isNotEmpty) {
      buttons.add(const SizedBox(height: 12));
    }

    buttons.add(
      ElevatedButton(
        onPressed: () => _confirmDelete(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent[700],
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 40),
        ),
        child: const Text('Eliminar Convocatoria'),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons,
    );
  }
}