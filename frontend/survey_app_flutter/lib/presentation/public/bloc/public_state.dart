import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// State class for the public survey page.
class PublicState extends Equatable {
  /// Creates a [PublicState].
  const PublicState({
    this.isLoading = false,
    this.survey,
    this.errorMessage,
    this.isSubmitting = false,
    this.submissionError,
    this.isSubmitted = false,
    this.answers = const <AnswerEntity>[],
    this.warningMessages = const <String>[],
  });

  /// Whether the survey is currently being loaded.
  final bool isLoading;

  /// Loaded survey for the current slug/token.
  final SurveyEntity? survey;

  /// Error message when loading fails (INVALID, CLOSED, ALREADY_SUBMITTED).
  final String? errorMessage;

  /// Whether the response is currently being submitted.
  final bool isSubmitting;

  /// Error message when submission fails.
  final String? submissionError;

  /// Whether the response has been successfully submitted.
  final bool isSubmitted;

  /// List of answers provided by the user for each question.
  final List<AnswerEntity> answers;

  /// Validation warnings shown when required questions are unanswered.
  final List<String> warningMessages;

  /// Returns a new [PublicState] with updated values.
  PublicState copyWith({
    bool? isLoading,
    SurveyEntity? survey,
    String? errorMessage,
    bool? isSubmitting,
    String? submissionError,
    bool? isSubmitted,
    List<AnswerEntity>? answers,
    List<String>? warningMessages,
  }) {
    return PublicState(
      isLoading: isLoading ?? this.isLoading,
      survey: survey ?? this.survey,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: submissionError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      answers: answers ?? this.answers,
      warningMessages: warningMessages ?? this.warningMessages,
    );
  }

  /// Returns a new [PublicState] with selected nullable fields reset.
  PublicState copyWithNull({
    bool nullSurvey = false,
    bool nullErrorMessage = false,
    bool nullSubmissionError = false,
  }) {
    return PublicState(
      isLoading: isLoading,
      survey: nullSurvey ? null : survey,
      errorMessage: nullErrorMessage ? null : errorMessage,
      isSubmitting: isSubmitting,
      submissionError: nullSubmissionError ? null : submissionError,
      isSubmitted: isSubmitted,
      answers: answers,
      warningMessages: warningMessages,
    );
  }

  /// Gets all answers for a specific question.
  List<AnswerEntity> getAnswersForQuestion(String questionId) {
    return answers.where((a) => a.questionId == questionId).toList();
  }

  @override
  List<Object?> get props => [
    isLoading,
    survey,
    errorMessage,
    isSubmitting,
    submissionError,
    isSubmitted,
    answers,
    warningMessages,
  ];
}
