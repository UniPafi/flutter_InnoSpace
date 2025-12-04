import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_bloc.dart';
import 'package:flutter_innospace/features/postulations/presentation/blocs/postulations_state.dart';
import 'package:flutter_innospace/features/postulations/presentation/widgets/postulation_card_widget.dart';

class PostulationsPage extends StatelessWidget {
  final int managerId;

  const PostulationsPage({super.key, required this.managerId});

  @override
  Widget build(BuildContext context) {
    // Definición de colores del diseño
    const Color primaryPurple = Color(0xFF673AB7);
    const Color lightGrayBg = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: lightGrayBg, // 1. Fondo gris claro
      appBar: AppBar(
        title: const Text(
          "Mis Postulaciones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // 2. Encabezado Morado con texto blanco y bordes redondeados
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: BlocBuilder<PostulationsBloc, PostulationsState>(
        builder: (context, state) {
          if (state is PostulationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostulationsLoaded) {
            if (state.postulations.isEmpty) {
              return const Center(child: Text("No postulations found"));
            }

            return ListView.builder(
              // Ajustamos el padding vertical para que no choque con el AppBar redondeado
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: state.postulations.length,
              itemBuilder: (_, index) {
                return PostulationCardWidget(
                  postulation: state.postulations[index],
                );
              },
            );
          }

          if (state is PostulationsError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}