import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/paginated_comments_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';

/// Repository interface for managing survey responses.
abstract class ResponseRepository {
  /// Submits survey response answers for a given survey.
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
  });

  /// Fetches high-level invitation/response summary counts for a survey.
  Future<ResultsSummaryEntity> getSurveyResultsSummary({
    required String surveyId,
    String? token,
  });

  /// Fetches option-level statistics for all questions in a survey.
  Future<List<QuestionStatEntity>> getSurveyQuestionStats({
    required String surveyId,
    String? token,
  });

  /// Fetches text comments for a survey with optional search and filtering.
  Future<PaginatedCommentsEntity> getSurveyComments({
    required String surveyId,
    String query,
    int page,
    String? questionId,
    String? token,
  });

  /// Exports all survey results as CSV content.
  Future<String> exportSurveyResultsCsv({
    required String surveyId,
    String? token,
  });

  /// Starts or returns a live stream for survey result changes.
  Stream<void> watchSurveyResults({required String surveyId});

  /// Stops live results stream resources.
  ///
  /// If [surveyId] is provided, only that survey stream is stopped.
  /// If omitted, all survey streams are stopped.
  Future<void> stopWatchingSurveyResults({String? surveyId});
}
