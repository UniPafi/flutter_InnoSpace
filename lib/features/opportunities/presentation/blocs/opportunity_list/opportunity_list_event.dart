part of 'opportunity_list_bloc.dart';

abstract class OpportunityListEvent extends Equatable {
  const OpportunityListEvent();
  @override
  List<Object> get props => [];
}

class FetchOpportunities extends OpportunityListEvent {}