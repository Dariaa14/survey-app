/// A data class representing the preview information of a question in the survey builder.
enum QuestionType {
  /// A question where respondents can select one or more options from a list.
  multipleChoice,

  /// A question where respondents can provide their own text response.
  freeText,
}

/// A data class representing the preview information of a question in the survey builder.
class QuestionPreviewData {
  /// Unique identifier for the question.
  final int id;

  /// The title of the question.
  final String title;

  /// Checked if the question is required to be answered by respondents.
  final bool required;

  /// The type of the question (e.g., multiple choice, text, etc.).
  final QuestionType type;

  /// The list of options for multiple-choice questions (optional).
  final int? maxOptions;

  /// The maximum character length for free-text questions (optional).
  final int? maxLength;

  /// Creates a [QuestionPreviewData] instance with the given parameters.
  QuestionPreviewData({
    required this.id,
    required this.title,
    required this.type,
    this.required = false,
    this.maxOptions,
    this.maxLength,
  });
}
