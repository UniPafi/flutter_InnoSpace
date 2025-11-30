import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_innospace/core/utils/image_utils.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/student_application.dart';

class StudentApplicationCard extends StatelessWidget {
  final StudentApplication application;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const StudentApplicationCard({
    super.key,
    required this.application,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Lógica de estado
    final isPending = application.managerResponse.toUpperCase() == 'PENDIENTE' || 
                      application.managerResponse.toUpperCase() == 'PENDING' ||
                      application.managerResponse.isEmpty;

    // Lógica de imagen
    Uint8List? decodedImage;
    if (application.studentPhotoUrl.isNotEmpty) {
      decodedImage = decodeBase64Image(application.studentPhotoUrl);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabecera: Foto, Nombre y Estado ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  backgroundImage: (decodedImage != null)
                      ? MemoryImage(decodedImage)
                      : null,
                  child: (decodedImage == null)
                      ? Icon(Icons.person, size: 30, color: theme.colorScheme.primary)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.studentName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Teléfono
                      if (application.studentPhoneNumber.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                application.studentPhoneNumber,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Chip de Estado
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPending ? Colors.orange[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isPending ? Colors.orange.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          application.managerResponse.isNotEmpty ? application.managerResponse : 'Pendiente',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isPending ? Colors.orange[800] : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // --- Descripción del Perfil ---
            if (application.studentDescription.isNotEmpty) ...[
              Text(
                "Perfil:",
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                application.studentDescription,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],

            // --- Skills ---
            if (application.studentSkills.isNotEmpty) ...[
              Text(
                "Habilidades:",
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: application.studentSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    labelStyle: const TextStyle(fontSize: 11),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // --- Botones de Acción (Solo si está pendiente) ---
            if (isPending) 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Aceptar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}