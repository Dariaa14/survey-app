import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/answer_entity_impl.dart';
import 'package:survey_app_flutter/data/entities_impl/question_stat_entity_impl.dart';
import 'package:survey_app_flutter/data/entities_impl/results_summary_entity_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/results_live_updates_client.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';

/// Concrete implementation of [ResponseRepository] that interacts with
/// a RESTful API to submit survey responses.
class ResponseRepositoryImpl implements ResponseRepository {
  /// Base URL for the API.
  final String baseUrl = 'http://localhost:3000/api';

  final Map<String, ResultsLiveUpdatesClient> _liveUpdatesClients = {};

  Map<String, String> _buildHeaders({String? token, bool csv = false}) {
    return <String, String>{
      if (!csv) 'Content-Type': 'application/json',
      if (csv) 'Accept': 'text/csv',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer ${token.trim()}',
    };
  }

  @override
  Future<void> submitSurveyResponse({
    required String slug,
    required String token,
    required List<AnswerEntity> answers,
  }) async {
    final uri = Uri.parse('$baseUrl/public/surveys/$slug/responses?t=$token');

    final payloadAnswers = answers.map((answer) {
      if (answer is AnswerEntityImpl) {
        return answer.toJson();
      }

      return <String, dynamic>{
        'question_id': answer.questionId,
        if ((answer.optionId ?? '').isNotEmpty) 'option_id': answer.optionId,
        if ((answer.textValue ?? '').trim().isNotEmpty)
          'text_value': answer.textValue!.trim(),
      };
    }).toList();

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'answers': payloadAnswers,
      }),
    );

    if (response.statusCode != 201) {
      final errorBody = response.body;
      if (errorBody.contains('ALREADY_SUBMITTED')) {
        throw Exception('You have already submitted this survey');
      }
      throw Exception('Failed to submit survey response: ${response.body}');
    }
  }

  @override
  Future<ResultsSummaryEntity> getSurveyResultsSummary({
    required String surveyId,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/surveys/$surveyId/results/summary');

    final response = await http.get(uri, headers: _buildHeaders(token: token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ResultsSummaryEntityImpl.fromJson(data);
    }

    throw Exception('Failed to fetch results summary: ${response.body}');
  }

  @override
  Future<List<QuestionStatEntity>> getSurveyQuestionStats({
    required String surveyId,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/surveys/$surveyId/results/questions');

    final response = await http.get(uri, headers: _buildHeaders(token: token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (item) => QuestionStatEntityImpl.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    }

    throw Exception('Failed to fetch question stats: ${response.body}');
  }

  @override
  Future<List<AnswerEntity>> getSurveyComments({
    required String surveyId,
    String query = '',
    int page = 1,
    String? questionId,
    String? token,
  }) async {
    final queryParameters = <String, String>{
      'q': query,
      'page': '$page',
      if (questionId != null && questionId.trim().isNotEmpty)
        'question_id': questionId.trim(),
    };

    final uri = Uri.parse('$baseUrl/surveys/$surveyId/results/comments')
        .replace(
          queryParameters: queryParameters,
        );

    final response = await http.get(uri, headers: _buildHeaders(token: token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      return data.map((item) {
        final json = Map<String, dynamic>.from(item as Map);
        json['page'] = page;
        return AnswerEntityImpl.fromJson(json);
      }).toList();
    }

    throw Exception('Failed to fetch comments: ${response.body}');
  }

  @override
  Future<String> exportSurveyResultsCsv({
    required String surveyId,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/surveys/$surveyId/results/export.csv');

    final response = await http.get(
      uri,
      headers: _buildHeaders(token: token, csv: true),
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Failed to export survey results CSV: ${response.body}');
  }

  @override
  Stream<void> watchSurveyResults({required String surveyId}) {
    final existingClient = _liveUpdatesClients[surveyId];
    if (existingClient != null) {
      return existingClient.updates;
    }

    final client = createResultsLiveUpdatesClient(
      baseUrl: baseUrl,
      surveyId: surveyId,
    );
    client.connect();
    _liveUpdatesClients[surveyId] = client;

    return client.updates;
  }

  @override
  Future<void> stopWatchingSurveyResults({String? surveyId}) async {
    if (surveyId != null) {
      final client = _liveUpdatesClients.remove(surveyId);
      client?.dispose();
      return;
    }

    for (final client in _liveUpdatesClients.values) {
      client.dispose();
    }
    _liveUpdatesClients.clear();
  }
}
