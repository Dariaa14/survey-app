/// Represents a single option-level statistic row for a survey question.
abstract class QuestionStatEntity {
  /// Survey question identifier.
  String get questionId;

  /// Survey question display text.
  String get questionText;

  /// Option identifier. Null for questions with no options.
  String? get optionId;

  /// Option display text. Null for questions with no options.
  String? get optionText;

  /// Number of responses selecting this option.
  int get count;

  /// Percentage of responses selecting this option.
  double get percentage;
}
