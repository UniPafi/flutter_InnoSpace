import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/postulations/domain/uses-cases/get_postulations.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_bloc.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_event.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_state.dart';
import 'package:flutter_innospace/features/postulations/presentation/widgets/postulation_card_widget.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener Manager ID de la sesión
    final sessionManager = context.read<SessionManager>();
    final managerId = sessionManager.getManagerId();

    // Colores del diseño
    const Color primaryPurple = Color(0xFF673AB7);
    const Color lightGrayBg = Color(0xFFF5F5F5);

    // Caso de seguridad si no hay sesión
    if (managerId == null) {
      return Scaffold(
        backgroundColor: lightGrayBg,
        appBar: AppBar(
          title: const Text('Solicitudes'),
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: const Center(child: Text("Error: Sesión no válida.")),
      );
    }

    return BlocProvider(
      create: (context) => PostulationsBloc(
        context.read<GetPostulationsUseCase>(),
      )..add(LoadPostulationsEvent(managerId)),
      child: Scaffold(
        backgroundColor: lightGrayBg, // Fondo gris claro
        appBar: AppBar(
          title: const Text(
            'Solicitudes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Quitar flecha de "atrás" si está en el tab principal
          elevation: 4,
          // Encabezado Morado con bordes redondeados
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: BlocBuilder<PostulationsBloc, PostulationsState>(
          builder: (context, state) {
            // Estado de Carga
            if (state is PostulationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado de Error
            if (state is PostulationsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Ocurrió un error al cargar las solicitudes.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Estado Exitoso
            if (state is PostulationsLoaded) {
              if (state.postulations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes solicitudes activas.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              // Lista de Solicitudes
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: state.postulations.length,
                itemBuilder: (context, index) {
                  final postulation = state.postulations[index];
                  // Usamos el widget estilizado anteriormente
                  return PostulationCardWidget(postulation: postulation);
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