import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// This file contains the event classes for the SurveyBuilderBloc.
abstract class SurveyBuilderEvent {}

/// Event to load an existing survey for editing in the survey builder.
class LoadSurveyForEditing extends SurveyBuilderEvent {
  /// The survey to be loaded for editing.
  final SurveyEntity survey;

  /// Creates a [LoadSurveyForEditing] event with the given [survey].
  LoadSurveyForEditing(this.survey);
}

/// Event to update the survey title in the survey builder.
class UpdateSurveyTitle extends SurveyBuilderEvent {
  /// The new title for the survey.
  final String title;

  /// Creates an [UpdateSurveyTitle] event with the given [title].
  UpdateSurveyTitle(this.title);
}

/// Event to update the survey description in the survey builder.
class UpdateSurveyDescription extends SurveyBuilderEvent {
  /// The new description for the survey.
  final String description;

  /// Creates an [UpdateSurveyDescription] event with the given [description].
  UpdateSurveyDescription(this.description);
}

/// Event to update the survey slug in the survey builder.
class UpdateSurveySlug extends SurveyBuilderEvent {
  /// The new slug for the survey.
  final String? slug;

  /// Creates an [UpdateSurveySlug] event with the given [slug].
  UpdateSurveySlug(this.slug);
}

/// Event to add a new question to the survey in the survey builder.
class AddQuestion extends SurveyBuilderEvent {
  /// The question to be added to the survey.
  final QuestionEntity question;

  /// Creates an [AddQuestion] event.
  AddQuestion(this.question);
}

/// Event to remove a question from the survey in the survey builder.
class RemoveQuestion extends SurveyBuilderEvent {
  /// The order number of the question to be removed from the survey.
  final int orderNumber;

  /// Creates a [RemoveQuestion] event with the given [orderNumber].
  RemoveQuestion(this.orderNumber);
}

/// Event to reorder questions in the survey builder.
class ReorderQuestions extends SurveyBuilderEvent {
  /// The original index of the question.
  final int oldIndex;

  /// The destination index of the question.
  final int newIndex;

  /// Creates a [ReorderQuestions] event.
  ReorderQuestions({required this.oldIndex, required this.newIndex});
}

/// Event to update an existing question in the survey builder.
class UpdateQuestion extends SurveyBuilderEvent {
  /// The updated question entity with the same id as the question being updated.
  final QuestionEntity question;

  /// Creates an [UpdateQuestion] event with the given [question].
  UpdateQuestion(this.question);
}

/// Event to save the survey being edited in the survey builder.
class SaveSurvey extends SurveyBuilderEvent {
  /// The status to set for the survey when saving (e.g. draft, published).
  final SurveyStatus status;

  /// The owner id to associate with the survey when saving.
  final String ownerId;

  /// Creates a [SaveSurvey] event.
  SaveSurvey(this.status, this.ownerId);
}
