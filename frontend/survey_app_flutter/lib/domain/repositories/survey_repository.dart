import 'package:survey_app_flutter/domain/entities/option_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// Interface for survey repository, defining methods for
/// survey-related data operations.
abstract class SurveyRepository {
  /// Fetches all surveys from the data source.
  Future<List<SurveyEntity>> getAllSurveys();

  /// Fetches surveys owned by a specific user.
  Future<List<SurveyEntity>> getSurveysByUser(
    String userId,
    String token, {
    String? status,
  });

  /// Fetches a survey by its unique identifier.
  Future<SurveyEntity> getSurveyById(String surveyId);

  /// Creates a new survey in the data source.
  Future<SurveyEntity> createSurvey({
    required String token,
    required String ownerId,
    required String title,
    required String description,
    required String slug,
    required SurveyStatus status,
  });

  /// Updates an existing survey in the data source.
  Future<SurveyEntity> updateSurvey(String token, SurveyEntity survey);

  /// Publishes a draft survey.
  Future<void> publishSurvey({required String token, required String surveyId});

  /// Closes a published survey.
  Future<void> closeSurvey({required String token, required String surveyId});

  /// Deletes a survey.
  Future<void> deleteSurvey({required String token, required String surveyId});

  /// Creates a new question in the specified survey.
  Future<QuestionEntity> createQuestion({
    required String surveyId,
    required String token,
    required QuestionType type,
    required String title,
    required bool required,
    required int order,
    int? maxLength,
    int? maxSelections,
    List<OptionEntity>? options,
  });

  /// Updates an existing question in the specified survey.
  Future<QuestionEntity> updateQuestion(
    String token,
    QuestionEntity question,
    String surveyId,
  );

  /// Deletes a question from the specified survey.
  Future<void> deleteQuestion({
    required String token,
    required String surveyId,
    required String questionId,
  });
}
