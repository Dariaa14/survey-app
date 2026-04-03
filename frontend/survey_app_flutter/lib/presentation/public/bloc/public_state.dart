import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// State class for the public survey page.
class PublicState extends Equatable {
  /// Creates a [PublicState].
  const PublicState({
    this.isLoading = false,
    this.survey,
    this.errorMessage,
  });

  /// Whether the survey is currently being loaded.
  final bool isLoading;

  /// Loaded survey for the current slug/token.
  final SurveyEntity? survey;

  /// Error message when loading fails.
  final String? errorMessage;

  /// Returns a new [PublicState] with updated values.
  PublicState copyWith({
    bool? isLoading,
    SurveyEntity? survey,
    String? errorMessage,
  }) {
    return PublicState(
      isLoading: isLoading ?? this.isLoading,
      survey: survey ?? this.survey,
      errorMessage: errorMessage,
    );
  }

  /// Returns a new [PublicState] with selected nullable fields reset.
  PublicState copyWithNull({
    bool nullSurvey = false,
    bool nullErrorMessage = false,
  }) {
    return PublicState(
      isLoading: isLoading,
      survey: nullSurvey ? null : survey,
      errorMessage: nullErrorMessage ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, survey, errorMessage];
}
