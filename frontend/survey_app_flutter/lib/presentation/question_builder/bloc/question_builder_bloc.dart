import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/data/entities_impl/question_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_state.dart';

/// This file defines the QuestionBuilderBloc, which manages the state of the
/// question builder feature in the survey app.
class QuestionBuilderBloc
    extends Bloc<QuestionBuilderEvent, QuestionBuilderState> {
  final SurveyUseCase _surveyUseCase;

  /// Constructs a [QuestionBuilderBloc] and initializes it with the initial
  /// state.
  QuestionBuilderBloc(this._surveyUseCase)
    : super(const QuestionBuilderState()) {
    on<QuestionTypeChanged>(_onQuestionTypeChanged);
    on<QuestionTitleChanged>(_onQuestionTitleChanged);
    on<QuestionRequiredChanged>(_onQuestionRequiredChanged);
    on<QuestionMaxLengthChanged>(_onQuestionMaxLengthChanged);
    on<QuestionMaxSelectionsChanged>(_onQuestionMaxSelectionsChanged);
    on<QuestionOptionsChanged>(_onQuestionOptionsChanged);
    on<QuestionOrderChanged>(_onQuestionOrderChanged);
    on<SaveQuestion>(_onSaveQuestion);
    on<QuestionBuilderReset>(_onQuestionBuilderReset);
  }

  void _onQuestionTypeChanged(
    QuestionTypeChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(state.copyWith(type: event.type));
  }

  void _onQuestionTitleChanged(
    QuestionTitleChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onQuestionRequiredChanged(
    QuestionRequiredChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(state.copyWith(required: event.required));
  }

  void _onQuestionMaxLengthChanged(
    QuestionMaxLengthChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    if (event.maxLength == null) {
      emit(state.copyWithNull(nullMaxLength: true));
      return;
    }
    emit(state.copyWith(maxLength: event.maxLength));
  }

  void _onQuestionMaxSelectionsChanged(
    QuestionMaxSelectionsChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    if (event.maxSelections == null) {
      emit(state.copyWithNull(nullMaxSelections: true));
      return;
    }
    emit(state.copyWith(maxSelections: event.maxSelections));
  }

  void _onQuestionOptionsChanged(
    QuestionOptionsChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(state.copyWith(options: event.options));
  }

  void _onQuestionOrderChanged(
    QuestionOrderChanged event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(state.copyWith(orderNumber: event.orderNumber));
  }

  void _onSaveQuestion(
    SaveQuestion event,
    Emitter<QuestionBuilderState> emit,
  ) {
    _surveyUseCase.createQuestion(
      surveyId: event.surveyId,
      token: event.token,
      type: state.type,
      title: state.title,
      required: state.required,
      order: event.order,
      maxLength: state.maxLength,
      maxSelections: state.maxSelections,
      options: state.options,
    );
  }

  void _onQuestionBuilderReset(
    QuestionBuilderReset event,
    Emitter<QuestionBuilderState> emit,
  ) {
    emit(const QuestionBuilderState());
  }

  /// Builds a [QuestionEntity] based on the current state of the question
  /// builder.
  QuestionEntity buildQuestionEntity() {
    return QuestionEntityImpl(
      id: '',
      surveyId: '',
      type: state.type,
      title: state.title,
      required: state.required,
      order: state.orderNumber,
      maxLength: state.maxLength,
      maxSelections: state.maxSelections,
      options: state.options,
    );
  }
}
