import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

part 'opportunity_detail_event.dart';
part 'opportunity_detail_state.dart';

class OpportunityDetailBloc extends Bloc<OpportunityDetailEvent, OpportunityDetailState> {
  final OpportunityRepository _repository;

  OpportunityDetailBloc(this._repository) : super(const OpportunityDetailState()) {
    on<FetchOpportunityDetail>(_onFetchDetail);
    on<PublishOpportunity>(_onPublish);
    on<CloseOpportunity>(_onClose);
    on<DeleteOpportunity>(_onDelete); // <-- AÑADIDO
  }

  Future<void> _onFetchDetail(
    FetchOpportunityDetail event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final opportunity = await _repository.getOpportunityById(event.id);
      emit(state.copyWith(status: Status.success, opportunity: opportunity));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onPublish(
    PublishOpportunity event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    if (state.opportunity == null) return;
    emit(state.copyWith(status: Status.loading));
    try {
      final updated = await _repository.publishOpportunity(state.opportunity!.id);
      emit(state.copyWith(status: Status.success, opportunity: updated));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onClose(
    CloseOpportunity event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    if (state.opportunity == null) return;
    emit(state.copyWith(status: Status.loading));
    try {
      final updated = await _repository.closeOpportunity(state.opportunity!.id);
      emit(state.copyWith(status: Status.success, opportunity: updated));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  // ---
  // ¡NUEVO MANEJADOR AÑADIDO!
  // ---
  Future<void> _onDelete(
    DeleteOpportunity event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    if (state.opportunity == null) return;
    emit(state.copyWith(status: Status.loading));
    try {
      await _repository.deleteOpportunity(state.opportunity!.id);
      emit(state.copyWith(status: Status.success, isDeleted: true)); // <-- Avisa que se borró
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}