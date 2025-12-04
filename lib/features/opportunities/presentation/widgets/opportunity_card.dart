import 'package:flutter/material.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  Color _getStatusColor(OpportunityStatus status) {
    if (status == OpportunityStatus.PUBLISHED) return const Color(0xFF66BB6A); // Green
    return const Color(0xFFFFB74D); // Orange/Amber for draft
  }

  @override
  Widget build(BuildContext context) {
    final bool isPublished = opportunity.status == OpportunityStatus.PUBLISHED;
    final String statusText = isPublished ? "Publicado" : "Borrador";
    final Color statusColor = _getStatusColor(opportunity.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left Color Strip
              Container(
                width: 5,
                color: statusColor,
              ),
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                opportunity.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Status Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // Summary (all caps "RESUMEN" look from image)
                        Text(
                          opportunity.summary.isNotEmpty ? opportunity.summary : "SIN RESUMEN",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Category with Icon
                        Row(
                          children: [
                            if (opportunity.category == "IT" || opportunity.category == "App Movil")
                              Icon(
                                opportunity.category == "App Movil" ? Icons.category : Icons.computer,
                                size: 14, 
                                color: const Color(0xFF42A5F5)
                              )
                            else
                              const Icon(Icons.category, size: 14, color: Color(0xFF42A5F5)),
                            
                            const SizedBox(width: 5),
                            Text(
                              opportunity.category,
                              style: const TextStyle(color: Color(0xFF42A5F5), fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}