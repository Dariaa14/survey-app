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

/// Submits survey response answers.
class PublicResponseSubmitted extends PublicEvent {
  /// Constructs a [PublicResponseSubmitted] event.
  PublicResponseSubmitted({
    required this.slug,
    required this.token,
    required this.answers,
  });

  /// Survey slug identifier.
  final String slug;

  /// Invitation token for authorization.
  final String token;

  /// List of answer entities submitted by the user.
  final List<AnswerEntity> answers;
}
