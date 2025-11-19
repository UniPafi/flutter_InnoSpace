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
    switch (status) {
      case OpportunityStatus.PUBLISHED:
        return Colors.green;
      case OpportunityStatus.CLOSED:
        return Colors.red;
      case OpportunityStatus.DRAFT:
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Expanded(
                    child: Text(
                      opportunity.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(opportunity.status.name),
                    backgroundColor: _getStatusColor(opportunity.status),
                    labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Chip(
                label: Text(
                  opportunity.category.isNotEmpty 
                    ? opportunity.category 
                    : "Sin Categoría",
                ),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 12
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              ),
              const SizedBox(height: 12),

             
              Text(
                opportunity.summary.isNotEmpty
                  ? opportunity.summary
                  : "Esta convocatoria no tiene un resumen.",
                style: opportunity.summary.isNotEmpty
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600]
                      ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}