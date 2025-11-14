part of 'create_opportunity_bloc.dart';

class CreateOpportunityState extends Equatable {
  final Status status;
  final String title;
  final String summary; // <-- CORREGIDO A 2 'm'
  final String description;
  final String category;
  final String requirements; // Simple string por ahora
  final String? errorMessage;

  const CreateOpportunityState({
    this.status = Status.initial,
    this.title = '',
    this.summary = '', // <-- CORREGIDO A 2 'm'
    this.description = '',
    this.category = '',
    this.requirements = '',
    this.errorMessage,
  });

  CreateOpportunityState copyWith({
    Status? status,
    String? title,
    String? summary, // <-- CORREGIDO A 2 'm'
    String? description,
    String? category,
    String? requirements,
    String? errorMessage,
  }) {
    return CreateOpportunityState(
      status: status ?? this.status,
      title: title ?? this.title,
      summary: summary ?? this.summary, // <-- CORREGIDO A 2 'm'
      description: description ?? this.description,
      category: category ?? this.category,
      requirements: requirements ?? this.requirements,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, title, summary, description, category, requirements, errorMessage]; // <-- CORREGIDO A 2 'm'
}