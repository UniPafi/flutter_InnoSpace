import 'dart:convert';

class CreateOpportunityDto {
  final int companyId;
  final String title;
  final String description;
  final String summary; 
  final String category;
  final List<String> requirements;

  CreateOpportunityDto({
    required this.companyId,
    required this.title,
    required this.description,
    required this.summary,
    required this.category,
    required this.requirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'summary': summary, 
      'category': category,
      'requirements': requirements,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}