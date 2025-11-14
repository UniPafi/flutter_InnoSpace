part of 'opportunity_detail_bloc.dart';

class OpportunityDetailState extends Equatable {
  final Status status;
  final Opportunity? opportunity;
  final String? errorMessage;
  final bool isDeleted; 

  const OpportunityDetailState({
    this.status = Status.initial,
    this.opportunity,
    this.errorMessage,
    this.isDeleted = false, 
  });

  OpportunityDetailState copyWith({
    Status? status,
    Opportunity? opportunity,
    String? errorMessage,
    bool? isDeleted, 
  }) {
    return OpportunityDetailState(
      status: status ?? this.status,
      opportunity: opportunity ?? this.opportunity,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleted: isDeleted ?? this.isDeleted, 
    );
  }

  @override
  List<Object?> get props => [status, opportunity, errorMessage, isDeleted]; 
}