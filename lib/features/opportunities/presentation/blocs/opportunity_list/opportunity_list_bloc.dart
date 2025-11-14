import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

part 'opportunity_list_event.dart';
part 'opportunity_list_state.dart';

class OpportunityListBloc extends Bloc<OpportunityListEvent, OpportunityListState> {
  final OpportunityRepository _repository;

  OpportunityListBloc(this._repository) : super(const OpportunityListState()) {
    on<FetchOpportunities>(_onFetchOpportunities);
  }

  Future<void> _onFetchOpportunities(
    FetchOpportunities event,
    Emitter<OpportunityListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final opportunities = await _repository.getMyOpportunities();
      emit(state.copyWith(
        status: Status.success,
        opportunities: opportunities,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}