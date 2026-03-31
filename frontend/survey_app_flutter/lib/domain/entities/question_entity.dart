import 'package:survey_app_flutter/domain/entities/option_entity.dart';

/// This is the enum for the different types of questions that can be
/// created in the survey application.
enum QuestionType {
  /// A question that allows the respondent to enter free-form text.
  text,

  /// A question that allows the respondent to select options from a list.
  multipleChoice,
}

/// This file defines the [QuestionEntity] class, which represents a question
/// in the survey application.
abstract class QuestionEntity {
  /// Unique identifier for the question.
  String get id;

  /// The survey ID that this question belongs to.
  String get surveyId;

  /// The type of the question (e.g., text, multiple choice).
  QuestionType get type;

  /// The text of the question that will be displayed to respondents.
  String get title;

  /// Whether answering this question is required or optional.
  bool get required;

  /// The order of the question within the survey.
  int get order;

  /// For text questions, the maximum number of characters allowed in
  ///  the response.
  int? get maxLength;

  /// For multiple choice questions, the maximum number of options that can be
  /// selected by respondents.
  int? get maxSelections;

  /// For multiple choice questions, the list of options that respondents can
  /// select from.
  List<OptionEntity>? get options;

  /// Returns a new question entity with updated fields.
  QuestionEntity copyWith({
    String? id,
    String? surveyId,
    QuestionType? type,
    String? title,
    bool? required,
    int? order,
    int? maxLength,
    int? maxSelections,
    List<OptionEntity>? options,
  });
}
