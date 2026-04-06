import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/use_cases/response_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_event.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_state.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Bloc for managing the state of the public survey page.
class PublicBloc extends Bloc<PublicEvent, PublicState> {
  /// Constructs a [PublicBloc] with the required use cases.
  PublicBloc(this._surveyUseCase, this._responseUseCase)
    : super(const PublicState()) {
    on<PublicSurveyRequested>(_onPublicSurveyRequested);
    on<PublicAnswerAdded>(_onPublicAnswerAdded);
    on<PublicAnswersRemoved>(_onPublicAnswersRemoved);
    on<PublicResponseSubmitted>(_onPublicResponseSubmitted);
  }

  final SurveyUseCase _surveyUseCase;
  final ResponseUseCase _responseUseCase;

  String _extractBackendError(Object error) {
    final raw = error.toString();

    final jsonErrorMatch = RegExp(
      r'"error"\s*:\s*"([^"]+)"',
      caseSensitive: false,
    ).firstMatch(raw);
    if (jsonErrorMatch != null) {
      return jsonErrorMatch.group(1)!.trim();
    }

    final allTokens = RegExp(r'\b[A-Z][A-Z_]{2,}\b').allMatches(raw);
    const ignoredTokens = <String>{
      'EXCEPTION',
      'FAILED',
      'FETCH',
      'PUBLIC',
      'SURVEY',
      'HTTP',
      'ERROR',
    };

    for (final match in allTokens.toList().reversed) {
      final token = match.group(0)!;
      if (!ignoredTokens.contains(token)) {
        return token;
      }
    }

    return raw.replaceFirst('Exception: ', '').trim();
  }

  void _onPublicAnswerAdded(
    PublicAnswerAdded event,
    Emitter<PublicState> emit,
  ) {
    if (event.answers.isEmpty) return;

    final questionId = event.answers.first.questionId;
    final updatedAnswers = List<AnswerEntity>.from(state.answers);

    // Remove existing answers for this question
    updatedAnswers.removeWhere((a) => a.questionId == questionId);

    // Add the new answers
    updatedAnswers.addAll(event.answers);

    emit(
      state.copyWith(
        answers: updatedAnswers,
        warningMessages: const <String>[],
      ),
    );
  }

  void _onPublicAnswersRemoved(
    PublicAnswersRemoved event,
    Emitter<PublicState> emit,
  ) {
    final updatedAnswers = List<AnswerEntity>.from(state.answers);
    updatedAnswers.removeWhere((a) => a.questionId == event.questionId);
    emit(
      state.copyWith(
        answers: updatedAnswers,
        warningMessages: const <String>[],
      ),
    );
  }

  Future<void> _onPublicSurveyRequested(
    PublicSurveyRequested event,
    Emitter<PublicState> emit,
  ) async {
    final trimmedSlug = event.slug.trim();
    final trimmedToken = event.token.trim();

    if (trimmedSlug.isEmpty || trimmedToken.isEmpty) {
      emit(
        state
            .copyWith(
              isLoading: false,
              errorMessage: 'Missing survey slug or token.',
            )
            .copyWithNull(nullSurvey: true),
      );
      return;
    }

    emit(
      state.copyWith(isLoading: true).copyWithNull(nullErrorMessage: true),
    );

    try {
      final survey = await _surveyUseCase.getPublicSurveyBySlug(
        slug: trimmedSlug,
        token: trimmedToken,
      );

      emit(
        state
            .copyWith(
              isLoading: false,
              survey: survey,
              answers: const <AnswerEntity>[],
              warningMessages: const <String>[],
            )
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state
            .copyWith(
              isLoading: false,
              errorMessage: _extractBackendError(e),
            )
            .copyWithNull(nullSurvey: true),
      );
    }
  }

  Future<void> _onPublicResponseSubmitted(
    PublicResponseSubmitted event,
    Emitter<PublicState> emit,
  ) async {
    final survey = state.survey;
    if (survey == null) {
      emit(
        state.copyWith(
          submissionError: 'Could not load survey. Please check the link.',
        ),
      );
      return;
    }

    final warnings = <String>[];
    for (final question in survey.questions) {
      if (!question.required) {
        continue;
      }

      final answersForQuestion = state.getAnswersForQuestion(question.id);
      if (question.type == QuestionType.multipleChoice) {
        final hasSelectedOption = answersForQuestion.any(
          (answer) => answer.optionId != null,
        );
        if (!hasSelectedOption) {
          warnings.add(
            AppStrings.publicRequiredSelectWarning(question.order),
          );
        }
        continue;
      }

      if (question.type == QuestionType.text) {
        final hasTextAnswer = answersForQuestion.any(
          (answer) => (answer.textValue ?? '').trim().isNotEmpty,
        );
        if (!hasTextAnswer) {
          warnings.add(
            AppStrings.publicRequiredTextWarning(question.order),
          );
        }
      }
    }

    if (warnings.isNotEmpty) {
      emit(
        state.copyWith(
          warningMessages: warnings,
          isSubmitting: false,
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(
            isSubmitting: true,
            warningMessages: const <String>[],
          )
          .copyWithNull(nullSubmissionError: true),
    );

    try {
      await _responseUseCase.submitSurveyResponse(
        slug: event.slug,
        token: event.token,
        answers: state.answers,
      );

      emit(state.copyWith(isSubmitting: false, isSubmitted: true));
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionError: _extractBackendError(e),
        ),
      );
    }
  }
}
