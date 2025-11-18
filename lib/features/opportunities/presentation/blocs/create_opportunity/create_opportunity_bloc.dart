import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/core/services/session_manager.dart';
import 'package:flutter_innospace/features/opportunities/data/models/create_opportunity_dto.dart';
import 'package:flutter_innospace/features/opportunities/domain/repositories/opportunity_repository.dart';

part 'create_opportunity_event.dart';
part 'create_opportunity_state.dart';

class CreateOpportunityBloc extends Bloc<CreateOpportunityEvent, CreateOpportunityState> {
  final OpportunityRepository _repository;
  final SessionManager _sessionManager;

  CreateOpportunityBloc(this._repository, this._sessionManager) : super(const CreateOpportunityState()) {
    on<TitleChanged>((event, emit) => emit(state.copyWith(title: event.title)));
    on<SummaryChanged>((event, emit) => emit(state.copyWith(summary: event.summary))); // <-- CORREGIDO
    on<DescriptionChanged>((event, emit) => emit(state.copyWith(description: event.description)));
    on<CategoryChanged>((event, emit) => emit(state.copyWith(category: event.category)));
    on<RequirementsChanged>((event, emit) => emit(state.copyWith(requirements: event.requirements)));
    on<FormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<CreateOpportunityState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    
    final int managerId = _sessionManager.getManagerId() ?? 0;
    if (managerId == 0) {
      emit(state.copyWith(status: Status.error, errorMessage: "Error: No se encontró ID de manager."));
      return;
    }
    
    final requirementsList = state.requirements.split(',').map((e) => e.trim()).toList();

    final createDto = CreateOpportunityDto(
      companyId: managerId,
      title: state.title,
      description: state.description,
      summary: state.summary, 
      category: state.category,
      requirements: requirementsList,
    );

    try {
      await _repository.createOpportunity(createDto);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}