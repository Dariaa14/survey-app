import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// State class for the public survey page.
class PublicState extends Equatable {
  /// Creates a [PublicState].
  const PublicState({
    this.isLoading = false,
    this.survey,
    this.errorMessage,
    this.mockAlreadyAnswered = false,
    this.isSubmitting = false,
    this.submissionError,
    this.isSubmitted = false,
  });

  /// Whether the survey is currently being loaded.
  final bool isLoading;

  /// Loaded survey for the current slug/token.
  final SurveyEntity? survey;

  /// Error message when loading fails.
  final String? errorMessage;

  /// Temporary mock flag for the already-answered page state.
  final bool mockAlreadyAnswered;

  /// Whether the response is currently being submitted.
  final bool isSubmitting;

  /// Error message when submission fails.
  final String? submissionError;

  /// Whether the response has been successfully submitted.
  final bool isSubmitted;

  /// Returns a new [PublicState] with updated values.
  PublicState copyWith({
    bool? isLoading,
    SurveyEntity? survey,
    String? errorMessage,
    bool? mockAlreadyAnswered,
    bool? isSubmitting,
    String? submissionError,
    bool? isSubmitted,
  }) {
    return PublicState(
      isLoading: isLoading ?? this.isLoading,
      survey: survey ?? this.survey,
      errorMessage: errorMessage,
      mockAlreadyAnswered: mockAlreadyAnswered ?? this.mockAlreadyAnswered,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: submissionError,
      isSubmitted: isSubmitted ?? this.isSubmitted,
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
      mockAlreadyAnswered: mockAlreadyAnswered,
      isSubmitting: isSubmitting,
      submissionError: nullSubmissionError ? null : submissionError,
      isSubmitted: isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    survey,
    errorMessage,
    mockAlreadyAnswered,
    isSubmitting,
    submissionError,
    isSubmitted,
  ];
}
