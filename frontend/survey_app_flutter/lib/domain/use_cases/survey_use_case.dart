import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';

/// This file defines the SurveyUseCase class, which will contain the business
/// logic related to surveys.
class SurveyUseCase {
  final SurveyRepository _surveyRepository;

  /// Constructs a [SurveyUseCase] with the given [SurveyRepository].
  SurveyUseCase(SurveyRepository surveyRepository)
    : _surveyRepository = surveyRepository;

  /// Fetches all surveys.
  Future<List<SurveyEntity>> getAllSurveys() async {
    return _surveyRepository.getAllSurveys();
  }

  /// Fetches a survey by its unique identifier.
  Future<SurveyEntity> getSurveyById(String surveyId) async {
    return _surveyRepository.getSurveyById(surveyId);
  }

  /// Fetches surveys created by a specific user.
  Future<List<SurveyEntity>> getSurveysByOwnerId(String ownerId) async {
    return _surveyRepository.getSurveysByUser(ownerId);
  }

  /// Creates a new survey.
  Future<SurveyEntity> createSurvey(SurveyEntity survey) async {
    return _surveyRepository.createSurvey(survey);
  }

  /// Updates an existing survey.
  Future<SurveyEntity> updateSurvey(SurveyEntity survey) async {
    return _surveyRepository.updateSurvey(survey);
  }
}
