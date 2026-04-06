import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';

/// Concrete implementation of [ResponseRepository] that interacts with
/// a RESTful API to submit survey responses.
class ResponseRepositoryImpl implements ResponseRepository {
  /// Base URL for the API.
  final String baseUrl = 'http://localhost:3000/api/surveys';

  @override
  Future<void> submitSurveyResponse({
    required String slug,
    required String token,
    required List<AnswerEntity> answers,
  }) async {
    final uri = Uri.parse('$baseUrl/$slug/responses?t=$token');

    // Convert answer entities to the backend format
    final formattedAnswers = <Map<String, dynamic>>[];

    // Group answers by question ID to handle multiple option selections
    final questionAnswers = <String, Map<String, dynamic>>{};

    for (final answer in answers) {
      if (!questionAnswers.containsKey(answer.questionId)) {
        questionAnswers[answer.questionId] = {
          'question_id': answer.questionId,
          'option_ids': <String>[],
        };
      }

      if (answer.optionId != null) {
        // Multiple choice - add option ID
        questionAnswers[answer.questionId]!['option_ids'].add(answer.optionId);
      } else if (answer.textValue != null &&
          answer.textValue!.trim().isNotEmpty) {
        // Text answer - only include if not empty
        questionAnswers[answer.questionId]!['text_value'] = answer.textValue!
            .trim();
      }
    }

    // Filter out empty answers and format for API
    for (final entry in questionAnswers.values) {
      final optionIds = entry['option_ids'] as List<String>?;
      final textValue = entry['text_value'] as String?;

      if ((optionIds?.isNotEmpty ?? false) ||
          (textValue?.isNotEmpty ?? false)) {
        // Only include provided answers
        final answer = <String, dynamic>{
          'question_id': entry['question_id'] as String,
        };
        if (optionIds?.isNotEmpty ?? false) {
          answer['option_ids'] = optionIds;
        }
        if (textValue?.isNotEmpty ?? false) {
          answer['text_value'] = textValue;
        }
        formattedAnswers.add(answer);
      }
    }

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'answers': formattedAnswers,
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
