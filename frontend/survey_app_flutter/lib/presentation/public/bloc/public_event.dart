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
