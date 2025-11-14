part of 'create_opportunity_bloc.dart';

abstract class CreateOpportunityEvent extends Equatable {
  const CreateOpportunityEvent();
  @override
  List<Object> get props => [];
}

class TitleChanged extends CreateOpportunityEvent {
  final String title;
  const TitleChanged(this.title);
}

class SummaryChanged extends CreateOpportunityEvent {
  final String summary;
  const SummaryChanged(this.summary);
}

class DescriptionChanged extends CreateOpportunityEvent {
  final String description;
  const DescriptionChanged(this.description);
}
class CategoryChanged extends CreateOpportunityEvent {
  final String category;
  const CategoryChanged(this.category);
}
class RequirementsChanged extends CreateOpportunityEvent {
  final String requirements;
  const RequirementsChanged(this.requirements);
}
class FormSubmitted extends CreateOpportunityEvent {}