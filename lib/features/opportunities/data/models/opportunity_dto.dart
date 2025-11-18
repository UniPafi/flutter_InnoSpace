import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';

class OpportunityDto {
  final int id;
  final int companyId;
  final String title;
  final String description;
  final String summary; 
  final String category;
  final List<String> requirements;
  final String status;

  OpportunityDto({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.summary, 
    required this.category,
    required this.requirements,
    required this.status,
  });

  factory OpportunityDto.fromJson(Map<String, dynamic> json) {
final rawId = json['id']?.toString();

    return OpportunityDto(
      id: rawId != null ? (int.tryParse(rawId) ?? 0) : 0,      
      companyId: json['companyId'] as int? ?? json['company'] as int? ?? 0,
    
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    summary: json['summary'] as String? ?? json['sumary'] as String? ?? '',
    
    category: json['category'] as String? ?? '',
    status: json['status'] as String? ?? 'DRAFT',

    requirements: List<String>.from(
        (json['requirements'] as List? ?? [])
            .map((x) => x.toString())
            ),
    );
  }

  Opportunity toDomain() {
    return Opportunity(
      id: id,
      companyId: companyId,
      title: title,
      description: description,
      summary: summary, 
      category: category,
      requirements: requirements,
      status: OpportunityStatus.fromString(status),
    );
  }
}