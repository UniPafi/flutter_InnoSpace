import 'package:flutter/material.dart';
import 'package:flutter_innospace/features/postulations/domain/models/postulation_card.dart';

class PostulationCardWidget extends StatelessWidget {
  final PostulationCard postulation;

  const PostulationCardWidget({super.key, required this.postulation});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color morado consistente con el tema
    const Color primaryPurple = Color(0xFF673AB7);

    return Card(
      // Fondo blanco explícito y bordes redondeados
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              // Fondo suave por si la imagen tarda en cargar o tiene transparencia
              backgroundColor: primaryPurple.withOpacity(0.1),
              backgroundImage: NetworkImage(postulation.managerPhotoUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postulation.projectTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryPurple, // Título en morado
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    postulation.projectDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700], // Color de texto secundario
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(
                            postulation.studentResponse,
                          ).withOpacity(0.1), // Fondo suave según el estado
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                             color: _statusColor(postulation.studentResponse).withOpacity(0.3),
                             width: 1,
                          ),
                        ),
                        child: Text(
                          postulation.studentResponse,
                          style: TextStyle(
                            color: _statusColor(postulation.studentResponse),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}