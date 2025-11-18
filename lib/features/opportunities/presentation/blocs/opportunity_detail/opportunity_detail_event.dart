part of 'opportunity_detail_bloc.dart';

abstract class OpportunityDetailEvent extends Equatable {
  const OpportunityDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchOpportunityDetail extends OpportunityDetailEvent {
  final int id;
  const FetchOpportunityDetail(this.id);
}

class PublishOpportunity extends OpportunityDetailEvent {}

class CloseOpportunity extends OpportunityDetailEvent {}


class DeleteOpportunity extends OpportunityDetailEvent {}