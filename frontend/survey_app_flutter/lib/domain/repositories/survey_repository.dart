import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// Interface for survey repository, defining methods for
/// survey-related data operations.
abstract class SurveyRepository {
  /// Fetches all surveys from the data source.
  Future<List<SurveyEntity>> getAllSurveys();

  /// Fetches surveys owned by a specific user.
  Future<List<SurveyEntity>> getSurveysByUser(String userId);

  /// Fetches a survey by its unique identifier.
  Future<SurveyEntity> getSurveyById(String surveyId);

  /// Creates a new survey in the data source.
  Future<SurveyEntity> createSurvey(SurveyEntity survey);

  /// Updates an existing survey in the data source.
  Future<SurveyEntity> updateSurvey(SurveyEntity survey);
}
