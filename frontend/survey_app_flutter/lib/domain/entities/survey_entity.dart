/// Survey status values based on backend `status` enum.
enum SurveyStatus {
  /// Survey is editable but not yet published.
  draft,

  /// Survey is published and can collect responses.
  published,

  /// Survey is closed and no longer accepts responses.
  closed,
}

/// Domain contract for a survey entity.
abstract class SurveyEntity {
  /// Survey id (UUID).
  String get id;

  /// Survey owner id (UUID).
  String get ownerId;

  /// Public slug for survey link.
  String get slug;

  /// Survey title.
  String get title;

  /// Optional survey description.
  String? get description;

  /// Current survey status.
  SurveyStatus get status;

  /// Creation timestamp.
  DateTime get createdAt;

  /// Publish timestamp.
  DateTime? get publishedAt;

  /// Close timestamp.
  DateTime? get closedAt;
}
