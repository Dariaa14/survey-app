import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/paginated_comments_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';

/// Use case for handling survey response operations.
class ResponseUseCase {
  final ResponseRepository _responseRepository;

  /// Constructs a [ResponseUseCase] with the given [ResponseRepository].
  ResponseUseCase(ResponseRepository responseRepository)
    : _responseRepository = responseRepository;

  /// Submits a survey response with the provided answers.
  ///
  /// Parameters:
  ///   - [slug]: The survey slug identifier
  ///   - [token]: Authorization token for the invitation
  ///   - [answers]: List of answer entities containing question and response data
  ///
  /// Throws [Exception] if submission fails
  Future<void> submitSurveyResponse({
    required String slug,
    required String token,
    required List<AnswerEntity> answers,
  }) async {
    return _responseRepository.submitSurveyResponse(
      slug: slug,
      token: token,
      answers: answers,
    );
  }

  /// Fetches high-level invitation/response summary counts for a survey.
  Future<ResultsSummaryEntity> getSurveyResultsSummary({
    required String surveyId,
    String? token,
  }) async {
    return _responseRepository.getSurveyResultsSummary(
      surveyId: surveyId,
      token: token,
    );
  }

  /// Fetches option-level statistics for all questions in a survey.
  Future<List<QuestionStatEntity>> getSurveyQuestionStats({
    required String surveyId,
    String? token,
  }) async {
    return _responseRepository.getSurveyQuestionStats(
      surveyId: surveyId,
      token: token,
    );
  }

  /// Fetches text comments for a survey with optional search and filtering.
  Future<PaginatedCommentsEntity> getSurveyComments({
    required String surveyId,
    String query = '',
    int page = 1,
    String? questionId,
    String? token,
  }) async {
    return _responseRepository.getSurveyComments(
      surveyId: surveyId,
      query: query,
      page: page,
      questionId: questionId,
      token: token,
    );
  }

  /// Exports all survey results as CSV content.
  Future<String> exportSurveyResultsCsv({
    required String surveyId,
    String? token,
  }) async {
    return _responseRepository.exportSurveyResultsCsv(
      surveyId: surveyId,
      token: token,
    );
  }

  /// Starts or returns a live stream for survey result changes.
  Stream<void> watchSurveyResults({required String surveyId}) {
    return _responseRepository.watchSurveyResults(surveyId: surveyId);
  }

  /// Stops live results stream resources.
  Future<void> stopWatchingSurveyResults({String? surveyId}) {
    return _responseRepository.stopWatchingSurveyResults(surveyId: surveyId);
  }
}
