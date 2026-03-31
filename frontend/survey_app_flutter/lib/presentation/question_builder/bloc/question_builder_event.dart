import 'package:survey_app_flutter/domain/entities/question_entity.dart';

/// This file defines the events for the QuestionBuilderBloc,
/// which manages the state of the question builder feature in the survey
/// app.
abstract class QuestionBuilderEvent {}

/// Event triggered when the question type is changed in the question builder.
class QuestionTypeChanged extends QuestionBuilderEvent {
  /// The new question type selected by the user.
  final QuestionType type;

  /// Constructs a [QuestionTypeChanged] event with the given [type].
  QuestionTypeChanged(this.type);
}

/// Event triggered when the question title is changed in the question builder.
class QuestionTitleChanged extends QuestionBuilderEvent {
  /// The new title of the question entered by the user.
  final String title;

  /// Constructs a [QuestionTitleChanged] event with the given [title].
  QuestionTitleChanged(this.title);
}

/// Event triggered when the required status of the question is changed in
/// the question builder.
class QuestionRequiredChanged extends QuestionBuilderEvent {
  /// The new required status of the question (true if required, false if
  /// optional).
  final bool required;

  /// Constructs a [QuestionRequiredChanged] event with the given [required]
  /// status.
  QuestionRequiredChanged({this.required = false});
}

/// Event triggered when the maximum length for text questions is changed
/// in the question builder.
class QuestionMaxLengthChanged extends QuestionBuilderEvent {
  /// The new maximum length for the answer of a text question.
  final int? maxLength;

  /// Constructs a [QuestionMaxLengthChanged] event with the given [maxLength].
  QuestionMaxLengthChanged(this.maxLength);
}

/// Event triggered when the maximum number of selections for multiple
/// choice questions is changed in the question builder.
class QuestionMaxSelectionsChanged extends QuestionBuilderEvent {
  /// The new maximum number of selections allowed for a multiple
  /// choice question.
  final int? maxSelections;

  /// Constructs a [QuestionMaxSelectionsChanged] event with the given
  /// [maxSelections].
  QuestionMaxSelectionsChanged(this.maxSelections);
}

/// Event triggered when the options for a multiple choice question
///  are changed in the question builder.
class QuestionOptionsAdded extends QuestionBuilderEvent {
  /// The new option added to a multiple choice question.
  final String option;

  /// Constructs a [QuestionOptionsAdded] event with the given [option].
  QuestionOptionsAdded(this.option);
}

/// Event triggered when an option for a multiple choice question is edited
/// in the question builder.
class QuestionOptionChanged extends QuestionBuilderEvent {
  /// The index of the edited option.
  final int index;

  /// The new value of the edited option.
  final String newOption;

  /// Constructs a [QuestionOptionChanged] event.
  QuestionOptionChanged(this.index, this.newOption);
}

/// Event triggered when an option for a multiple choice question is removed
/// in the question builder.
class QuestionOptionRemoved extends QuestionBuilderEvent {
  /// The index of the removed option.
  final int index;

  /// Constructs a [QuestionOptionRemoved] event.
  QuestionOptionRemoved(this.index);
}

/// Event triggered when the order of the question is changed in the
/// question builder.
class QuestionOrderChanged extends QuestionBuilderEvent {
  /// The new order number of the question in the survey.
  final int orderNumber;

  /// Constructs a [QuestionOrderChanged] event with the given [orderNumber].
  QuestionOrderChanged(this.orderNumber);
}

/// Event triggered when the user saves the question in the question builder.
class SaveQuestion extends QuestionBuilderEvent {
  /// The unique identifier of the survey to which the question belongs.
  final String surveyId;

  /// The authentication token of the user creating or updating the question.
  final String token;

  /// The order of the question in the survey.
  final int order;

  /// Constructs a [SaveQuestion] event with the given [surveyId] and [token].
  SaveQuestion({
    required this.surveyId,
    required this.token,
    required this.order,
  });
}

/// Event triggered when the question builder is reset to its initial state.
class QuestionBuilderReset extends QuestionBuilderEvent {}
