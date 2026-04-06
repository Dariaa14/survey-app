import 'package:survey_app_flutter/domain/entities/answer_entity.dart';

/// Base class for public page events.
abstract class PublicEvent {}

/// Loads a public survey using the URL slug and token.
class PublicSurveyRequested extends PublicEvent {
  /// Constructs a [PublicSurveyRequested] event.
  PublicSurveyRequested({required this.slug, required this.token});

  /// Survey slug from route path.
  final String slug;

  /// Invitation token from query parameter.
  final String token;
}

/// Adds or updates answers for a question.
class PublicAnswerAdded extends PublicEvent {
  /// Constructs a [PublicAnswerAdded] event.
  PublicAnswerAdded({required this.answers});

  /// List of answer entities to add/update.
  /// For single answers: list contains one answer.
  /// For multiple choice with multiple selections: list contains multiple answers.
  final List<AnswerEntity> answers;
}

/// Removes all answers for a specific question.
class PublicAnswersRemoved extends PublicEvent {
  /// Constructs a [PublicAnswersRemoved] event.
  PublicAnswersRemoved({required this.questionId});

  /// The question ID whose answers should be removed.
  final String questionId;
}

/// Submits survey response answers.
class PublicResponseSubmitted extends PublicEvent {
  /// Constructs a [PublicResponseSubmitted] event.
  PublicResponseSubmitted({
    required this.slug,
    required this.token,
  });

  /// Survey slug identifier.
  final String slug;

  /// Invitation token for authorization.
  final String token;
}
