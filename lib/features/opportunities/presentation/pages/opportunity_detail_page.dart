import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/close_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/delete_opportunity_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/get_opportunity_by_id_use_case.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/publish_opportunity_use_case.dart';
import '../blocs/opportunity_detail/opportunity_detail_bloc.dart';
import 'package:flutter_innospace/features/opportunities/presentation/pages/student_applications_page.dart';

class OpportunityDetailPage extends StatelessWidget {
  final int opportunityId;

  const OpportunityDetailPage({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    // Colores
    const Color headerColor = Color(0xFF7E57C2);
    const Color backgroundColor = Color(0xFFEDE7F6);

    return BlocProvider<OpportunityDetailBloc>(
      create: (context) => OpportunityDetailBloc(
        context.read<GetOpportunityByIdUseCase>(),
        context.read<PublishOpportunityUseCase>(),
        context.read<CloseOpportunityUseCase>(),
        context.read<DeleteOpportunityUseCase>(),
      )..add(FetchOpportunityDetail(opportunityId)),
      child: Scaffold(
        backgroundColor: headerColor, // Fondo superior coincide con AppBar
        appBar: AppBar(
          title: const Text(
            'Detalle del Proyecto',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: headerColor,
          foregroundColor: Colors.white,
          elevation: 0,
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
                  content: Text('Proyecto eliminado'),
                  backgroundColor: Colors.green,
                ));
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            // Manejo de estados de carga y error
            if (state.status == Status.loading && state.opportunity == null) {
              return Container(
                color: backgroundColor,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            
            // Verificación de nulidad corregida
            final op = state.opportunity;
            if (op == null) {
              return Container(
                color: backgroundColor,
                child: const Center(child: Text('No se pudo cargar la información.')),
              );
            }

            // Aquí usamos 'op' que ya verificamos que no es nulo
            // Usamos un Container con bordes superiores redondeados para simular la card grande
            return Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        op.title,
                        style: const TextStyle(
                          color: Color(0xFF673AB7),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Estado y Categoría
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              op.status.name == 'DRAFT' ? 'Borrador' : op.status.name,
                              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            op.category,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Resumen
                      const Text(
                        'Resumen',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        op.summary.isNotEmpty ? op.summary : "Sin resumen",
                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 24),

                      // Descripción Detallada
                      const Text(
                        'Descripción Detallada',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        op.description,
                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 40),

                      // Botones de Acción
                      _buildActionButtons(context, op),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Opportunity opportunity) {
    final bloc = context.read<OpportunityDetailBloc>();
    List<Widget> buttons = [];

    // Estilo Botón Azul/Morado
    ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7986CB),
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
    );

    // Estilo Botón Eliminar (Rosa pálido)
    ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFCCBC),
      foregroundColor: Colors.black87,
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
    );

    if (opportunity.status != OpportunityStatus.DRAFT) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StudentApplicationsPage(opportunityId: opportunity.id),
              ),
            );
          },
          style: primaryButtonStyle,
          child: const Text('Ver Postulantes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
      buttons.add(const SizedBox(height: 16));
    }

    if (opportunity.status == OpportunityStatus.DRAFT) {
      buttons.add(
        ElevatedButton(
          onPressed: () {}, // Funcionalidad placeholder para editar
          style: primaryButtonStyle,
          child: const Text('Editar Proyecto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
      buttons.add(const SizedBox(height: 16));

      buttons.add(
        ElevatedButton(
          onPressed: () => bloc.add(PublishOpportunity()),
          style: primaryButtonStyle.copyWith(backgroundColor: const MaterialStatePropertyAll(Color(0xFF7E57C2))),
          child: const Text('Publicar Proyecto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    } else if (opportunity.status == OpportunityStatus.PUBLISHED) {
       buttons.add(
        ElevatedButton(
          onPressed: () => bloc.add(CloseOpportunity()),
          style: primaryButtonStyle.copyWith(backgroundColor: const MaterialStatePropertyAll(Colors.orange)),
          child: const Text('Marcar como Finalizado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (buttons.isNotEmpty) buttons.add(const SizedBox(height: 16));
    
    buttons.add(
      ElevatedButton(
        onPressed: () => _confirmDelete(context, bloc), // Pasar el bloc
        style: deleteButtonStyle,
        child: const Text('Eliminar Proyecto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons,
    );
  }

  void _confirmDelete(BuildContext context, OpportunityDetailBloc bloc) {
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("¿Seguro que deseas eliminar este proyecto?"),
        actions: [
          TextButton(onPressed: ()=> Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(onPressed: () {
            Navigator.pop(ctx);
            bloc.add(DeleteOpportunity());
          }, child: const Text("Eliminar", style: TextStyle(color: Colors.red))),
        ],
      ),
     );
  }
}