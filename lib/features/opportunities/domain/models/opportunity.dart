import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';

class Opportunity extends Equatable {
  final int id;
  final int companyId;
  final String title;
  final String description;
  final String summary;
  final String category;
  final List<String> requirements;
  final OpportunityStatus status;

  const Opportunity({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.summary, 
    required this.category,
    required this.requirements,
    required this.status,
  });

  @override
  List<Object?> get props => [id, companyId, title, description, summary, category, requirements, status];
}