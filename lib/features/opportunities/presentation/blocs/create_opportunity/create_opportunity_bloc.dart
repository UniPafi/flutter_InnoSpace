import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_innospace/core/enums/status.dart';

import 'package:flutter_innospace/features/opportunities/domain/use-cases/CreateOpportunityUseCase.dart';

part 'create_opportunity_event.dart';
part 'create_opportunity_state.dart';

class CreateOpportunityBloc extends Bloc<CreateOpportunityEvent, CreateOpportunityState> {
 final CreateOpportunityUseCase _createOpportunityUseCase;

  CreateOpportunityBloc(this._createOpportunityUseCase) : super(const CreateOpportunityState()) {
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

    
    final requirementsList = state.requirements.split(',').map((e) => e.trim()).toList();

   

   try {
      await _createOpportunityUseCase.call(
        title: state.title,
        description: state.description,
        summary: state.summary,
        category: state.category,
        requirements: requirementsList,
      );
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}