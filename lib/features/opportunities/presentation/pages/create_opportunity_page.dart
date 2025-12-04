import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/create_opportunity_use_case.dart';
import '../blocs/create_opportunity/create_opportunity_bloc.dart';

class CreateOpportunityPage extends StatelessWidget {
  const CreateOpportunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors from your images
    const Color headerPurple = Color(0xFF7E57C2);
    const Color backgroundLavender = Color(0xFFEDE7F6); 
    const Color buttonPurple = Color(0xFF673AB7);

    return BlocProvider<CreateOpportunityBloc>(
      create: (context) => CreateOpportunityBloc(
        context.read<CreateOpportunityUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: backgroundLavender,
        appBar: AppBar(
          title: const Text(
            'Crear Nueva Convocatoria',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: headerPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: 70,
        ),
        body: BlocConsumer<CreateOpportunityBloc, CreateOpportunityState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Text('Éxito'),
                  content: const Text('La convocatoria se ha creado como borrador.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(true);
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
            
            // Custom Input Builder matching image_361fa2.png
            Widget buildCustomInput({
              required String label, 
              required String hint, 
              int maxLines = 1,
              required Function(String) onChanged,
              bool isRequirement = false
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isRequirement ? headerPurple : Colors.grey[700],
                        fontSize: 14,
                        fontWeight: isRequirement ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: isRequirement ? Border.all(color: headerPurple, width: 1.5) : null,
                      boxShadow: [
                        if (!isRequirement)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                      ],
                    ),
                    child: TextField(
                      maxLines: maxLines,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  buildCustomInput(
                    label: 'Título',
                    hint: 'Nueva convo',
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(TitleChanged(value)),
                  ),
                  buildCustomInput(
                    label: 'Resumen (Summary)',
                    hint: 'hola',
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(SummaryChanged(value)),
                  ),
                  buildCustomInput(
                    label: 'Descripción',
                    hint: 'aqui que se pone',
                    maxLines: 4,
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(DescriptionChanged(value)),
                  ),
                  buildCustomInput(
                    label: 'Categoría',
                    hint: 'FrontEnd',
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(CategoryChanged(value)),
                  ),
                  buildCustomInput(
                    label: 'Requisitos',
                    hint: 'Vue, Node.js',
                    isRequirement: true, // Applies purple border from image
                    onChanged: (value) => context.read<CreateOpportunityBloc>().add(RequirementsChanged(value)),
                  ),
                  
                  const SizedBox(height: 32),

                  if (state.status == Status.loading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPurple,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            context.read<CreateOpportunityBloc>().add(FormSubmitted()),
                        child: const Text(
                          'Guardar Borrador',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
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