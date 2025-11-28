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
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Postulaciones")),
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
              padding: const EdgeInsets.all(16),
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
