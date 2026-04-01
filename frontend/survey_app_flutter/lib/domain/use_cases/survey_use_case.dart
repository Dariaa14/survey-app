import 'package:survey_app_flutter/domain/entities/option_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
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
  Future<List<SurveyEntity>> getSurveysByUser(
    String ownerId,
    String token,
  ) async {
    return _surveyRepository.getSurveysByUser(ownerId, token);
  }

  /// Creates a new survey.
  Future<SurveyEntity> createSurvey({
    required String token,
    required String ownerId,
    required String title,
    required String description,
    required String slug,
    required SurveyStatus status,
  }) async {
    return _surveyRepository.createSurvey(
      token: token,
      ownerId: ownerId,
      title: title,
      description: description,
      slug: slug,
      status: status,
    );
  }

  /// Updates an existing survey.
  Future<SurveyEntity> updateSurvey(String token, SurveyEntity survey) async {
    return _surveyRepository.updateSurvey(token, survey);
  }

  /// Publishes a draft survey.
  Future<void> publishSurvey({
    required String token,
    required String surveyId,
  }) async {
    return _surveyRepository.publishSurvey(token: token, surveyId: surveyId);
  }

  /// Deletes a survey.
  Future<void> deleteSurvey({
    required String token,
    required String surveyId,
  }) async {
    return _surveyRepository.deleteSurvey(token: token, surveyId: surveyId);
  }

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
  }) async {
    return _surveyRepository.createQuestion(
      surveyId: surveyId,
      token: token,
      type: type,
      title: title,
      required: required,
      order: order,
      maxLength: maxLength,
      maxSelections: maxSelections,
      options: options,
    );
  }

  /// Updates an existing question in the specified survey.
  Future<QuestionEntity> updateQuestion(
    String token,
    QuestionEntity question,
    String surveyId,
  ) async {
    return _surveyRepository.updateQuestion(token, question, surveyId);
  }

  /// Deletes a question from the specified survey.
  Future<void> deleteQuestion({
    required String token,
    required String surveyId,
    required String questionId,
  }) async {
    return _surveyRepository.deleteQuestion(
      token: token,
      surveyId: surveyId,
      questionId: questionId,
    );
  }
}
