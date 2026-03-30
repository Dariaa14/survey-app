import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:survey_app_flutter/data/entities_impl/survey_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';

/// Concrete implementation of [SurveyRepository] that interacts with
/// a RESTful API.
class SurveyRepositoryImpl implements SurveyRepository {
  final _storage = const FlutterSecureStorage();

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
  Future<List<SurveyEntity>> getSurveysByUser(String userId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('No auth token available.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
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
  Future<SurveyEntity> createSurvey(SurveyEntity survey) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode((survey as SurveyEntityImpl).toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SurveyEntityImpl.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to create survey');
    }
  }

  @override
  Future<SurveyEntity> updateSurvey(SurveyEntity survey) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${survey.id}'),
      headers: {'Content-Type': 'application/json'},
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
}
