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
    return OpportunityDto(
      id: int.tryParse(json['id'].toString()) ?? 0,
      
      companyId: (json['companyId'] ?? json['company']) as int? ?? 0,

      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',

  
      summary: (json['summary'] ?? json['sumary']) as String? ?? '',

      category: json['category'] as String? ?? '',
      status: json['status'] as String? ?? 'DRAFT',

      requirements: json['requirements'] == null
          ? <String>[]
          : List<String>.from(json['requirements'].map((x) => x as String)),
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