/// Entity representing an answer to a survey question.
abstract class AnswerEntity {
  /// Unique identifier for the answer.
  String get id;

  /// Identifier of the question this answer belongs to.
  String get questionId;

  /// Identifier of the response this answer belongs to.
  String get responseId;

  /// Identifier of the selected option for multiple choice
  /// questions, or null for text questions.
  String? get optionId;

  /// The text value of the answer for text
  /// questions, or null for multiple choice questions.
  String? get textValue;

  /// Email of the respondent for text comments, when available.
  String? get email;

  /// Submission timestamp for text comments, when available.
  String? get submittedAt;

  /// Page number for paginated comments. Null if not part of paginated results.
  int? get page;
}
