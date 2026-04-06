import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/answer_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';

/// Concrete implementation of [ResponseRepository] that interacts with
/// a RESTful API to submit survey responses.
class ResponseRepositoryImpl implements ResponseRepository {
  /// Base URL for the API.
  final String baseUrl = 'http://localhost:3000/api/public/surveys';

  @override
  Future<void> submitSurveyResponse({
    required String slug,
    required String token,
    required List<AnswerEntity> answers,
  }) async {
    final uri = Uri.parse('$baseUrl/$slug/responses?t=$token');

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
}
