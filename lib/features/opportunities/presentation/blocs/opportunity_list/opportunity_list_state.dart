part of 'opportunity_list_bloc.dart';

class OpportunityListState extends Equatable {
  final Status status;
  final List<Opportunity> opportunities;
  final String? errorMessage;

  const OpportunityListState({
    this.status = Status.initial,
    this.opportunities = const [],
    this.errorMessage,
  });

  OpportunityListState copyWith({
    Status? status,
    List<Opportunity>? opportunities,
    String? errorMessage,
  }) {
    return OpportunityListState(
      status: status ?? this.status,
      opportunities: opportunities ?? this.opportunities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, opportunities, errorMessage];
}