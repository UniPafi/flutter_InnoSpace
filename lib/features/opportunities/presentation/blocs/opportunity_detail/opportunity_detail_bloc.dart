import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/domain/models/opportunity.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/CloseOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/DeleteOpportunityUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/GetOpportunityByIdUseCase.dart';
import 'package:flutter_innospace/features/opportunities/domain/use-cases/PublishOpportunityUseCase.dart';

part 'opportunity_detail_event.dart';
part 'opportunity_detail_state.dart';

class OpportunityDetailBloc extends Bloc<OpportunityDetailEvent, OpportunityDetailState> {
  final GetOpportunityByIdUseCase _getDetail;
  final PublishOpportunityUseCase _publish;
  final CloseOpportunityUseCase _close;
  final DeleteOpportunityUseCase _delete;

  OpportunityDetailBloc(this._getDetail, this._publish, this._close, this._delete) : super(const OpportunityDetailState()) {
    on<FetchOpportunityDetail>(_onFetchDetail);
    on<PublishOpportunity>(_onPublish);
    on<CloseOpportunity>(_onClose);
    on<DeleteOpportunity>(_onDelete); 
  }

  Future<void> _onFetchDetail(
    FetchOpportunityDetail event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final opportunity = await _getDetail.call(id: event.id);
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
      final updated = await _publish.call(id: state.opportunity!.id);
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
      final updated = await _close.call(id: state.opportunity!.id);
      emit(state.copyWith(status: Status.success, opportunity: updated));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteOpportunity event,
    Emitter<OpportunityDetailState> emit,
  ) async {
    if (state.opportunity == null) return;
    emit(state.copyWith(status: Status.loading));
    try {
      await _delete.call(id: state.opportunity!.id);
      emit(state.copyWith(status: Status.success, isDeleted: true)); 
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}