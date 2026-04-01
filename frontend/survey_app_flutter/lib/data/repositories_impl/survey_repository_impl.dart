import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/question_entity_impl.dart';
import 'package:survey_app_flutter/data/entities_impl/survey_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/option_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';

/// Concrete implementation of [SurveyRepository] that interacts with
/// a RESTful API.
class SurveyRepositoryImpl implements SurveyRepository {
  /// Base URL for the survey API.
  final String baseUrl = 'http://localhost:3000/api/surveys';

  @override
  Future<List<SurveyEntity>> getAllSurveys() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (json) => SurveyEntityImpl.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to fetch surveys');
    }
  }

  @override
  Future<List<SurveyEntity>> getSurveysByUser(
    String userId,
    String token, {
    String? status,
  }) async {
    final uri = Uri.parse('$baseUrl/user/$userId').replace(
      queryParameters: status == null ? null : <String, String>{'status': status},
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (json) => SurveyEntityImpl.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to fetch user surveys');
    }
  }

  @override
  Future<SurveyEntity> getSurveyById(String surveyId) async {
    final response = await http.get(Uri.parse('$baseUrl/$surveyId'));
    if (response.statusCode == 200) {
      return SurveyEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to fetch survey');
    }
  }

  @override
  Future<SurveyEntity> createSurvey({
    required String token,
    required String ownerId,
    required String title,
    required String description,
    required String slug,
    required SurveyStatus status,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'owner_id': ownerId,
        'title': title,
        'description': description,
        'slug': slug,
        'status': _surveyStatusToJson(status),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SurveyEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create survey: ${response.body}');
    }
  }

  String _surveyStatusToJson(SurveyStatus status) {
    switch (status) {
      case SurveyStatus.draft:
        return 'draft';
      case SurveyStatus.published:
        return 'published';
      case SurveyStatus.closed:
        return 'closed';
    }
  }

  @override
  Future<SurveyEntity> updateSurvey(String token, SurveyEntity survey) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${survey.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode((survey as SurveyEntityImpl).toJson()),
    );

    if (response.statusCode == 200) {
      return SurveyEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to update survey');
    }
  }

  @override
  Future<void> publishSurvey({
    required String token,
    required String surveyId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId/publish'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to publish survey: ${response.body}');
    }
  }

  @override
  Future<void> closeSurvey({
    required String token,
    required String surveyId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId/close'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to close survey: ${response.body}');
    }
  }

  @override
  Future<void> deleteSurvey({
    required String token,
    required String surveyId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$surveyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete survey: ${response.body}');
    }
  }

  @override
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
    final questionTypeString = type == QuestionType.text ? 'text' : 'choice';

    final requestBody = {
      'type': questionTypeString,
      'title': title,
      'required': required,
      'order': order,
      if (maxLength != null) 'max_length': maxLength,
      if (maxSelections != null) 'max_selections': maxSelections,
      if (options != null && options.isNotEmpty)
        'options': options
            .map((opt) => {'label': opt.label, 'order': opt.order})
            .toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/$surveyId/questions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return QuestionEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create question');
    }
  }

  @override
  Future<QuestionEntity> updateQuestion(
    String token,
    QuestionEntity question,
    String surveyId,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$surveyId/questions/${question.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode((question as QuestionEntityImpl).toJson()),
    );

    if (response.statusCode == 200) {
      return QuestionEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to update question');
    }
  }

  @override
  Future<void> deleteQuestion({
    required String token,
    required String surveyId,
    required String questionId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$surveyId/questions/$questionId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete question: ${response.body}');
    }
  }
}
