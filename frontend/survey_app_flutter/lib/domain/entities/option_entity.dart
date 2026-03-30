/// Represents an option for a survey question.
abstract class OptionEntity {
  /// Option id (UUID).
  String get id;

  /// The survey ID that this option belongs to.
  String get questionId;

  /// Option text.
  String get label;

  /// Option order for display.
  int get order;
}
