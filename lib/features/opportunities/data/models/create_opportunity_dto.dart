import 'dart:convert';

// Representa el "CreateOpportunityResource" para el POST
class CreateOpportunityDto {
  final int companyId;
  final String title;
  final String description;
  final String summary; // <-- CORREGIDO A 2 'm'
  final String category;
  final List<String> requirements;

  CreateOpportunityDto({
    required this.companyId,
    required this.title,
    required this.description,
    required this.summary, // <-- CORREGIDO A 2 'm'
    required this.category,
    required this.requirements,
  });

  // Convierte nuestro objeto a un Map para el body de http
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'title': title,
      'description': description,
      'summary': summary, // <-- CORRECCIÓN CLAVE: Enviar 'summary' con 2 'm'
      'category': category,
      'requirements': requirements,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}