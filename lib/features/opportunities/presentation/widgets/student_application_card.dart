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
    const Color primaryPurple = Color(0xFF673AB7);
    
    final isPending = application.managerResponse.toUpperCase() == 'PENDIENTE' || 
                      application.managerResponse.toUpperCase() == 'PENDING' ||
                      application.managerResponse.isEmpty;

    Uint8List? decodedImage;
    if (application.studentPhotoUrl.isNotEmpty) {
      decodedImage = decodeBase64Image(application.studentPhotoUrl);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: decodedImage != null ? MemoryImage(decodedImage) : null,
                  backgroundColor: Colors.grey[200],
                  child: decodedImage == null ? const Icon(Icons.person, color: Colors.grey) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.studentName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (application.studentPhoneNumber.isNotEmpty) ...[
                         const SizedBox(height: 2),
                         Row(
                           children: [
                             const Icon(Icons.phone, size: 12, color: Colors.grey),
                             const SizedBox(width: 4),
                             Text(application.studentPhoneNumber, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                           ],
                         )
                      ],
                      const SizedBox(height: 4),
                      // Status Label if not pending
                      if (!isPending)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            application.managerResponse,
                            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            
            // Profile & Skills sections
            const Text("Perfil:", style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              application.studentDescription,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            if (application.studentSkills.isNotEmpty) ...[
              const Text("Habilidades:", style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: application.studentSkills.map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: primaryPurple.withOpacity(0.2)),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(color: primaryPurple.withOpacity(0.8), fontSize: 12),
                  ),
                )).toList(),
              ),
            ],
            
            // Buttons if pending
             if (isPending) ...[
               const SizedBox(height: 20),
               Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Rechazar"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Aceptar"),
                    ),
                  ),
                ],
               ),
             ],
          ],
        ),
      ),
    );
  }
}