import 'package:survey_app_flutter/data/entities_impl/question_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// Concrete implementation of [SurveyEntity] used in data layer.
class SurveyEntityImpl implements SurveyEntity {
  /// Creates a [SurveyEntityImpl].
  const SurveyEntityImpl({
    required this.id,
    required this.ownerId,
    required this.slug,
    required this.title,
    required this.status,
    required this.createdAt,
    this.questions = const [],
    this.description,
    this.publishedAt,
    this.closedAt,
  });

  /// Builds an instance from backend JSON payload.
  factory SurveyEntityImpl.fromJson(Map<String, dynamic> json) {
    return SurveyEntityImpl(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: _mapSurveyStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      publishedAt: _parseNullableDate(json['published_at']),
      closedAt: _parseNullableDate(json['closed_at']),
      questions: _parseQuestions(json['questions']),
    );
  }

  @override
  final String id;

  @override
  final String ownerId;

  @override
  final String slug;

  @override
  final String title;

  @override
  final String? description;

  @override
  final SurveyStatus status;

  @override
  final DateTime createdAt;

  @override
  final DateTime? publishedAt;

  @override
  final DateTime? closedAt;

  @override
  final List<QuestionEntity> questions;

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'slug': slug,
      'title': title,
      'description': description,
      'status': _surveyStatusToJson(status),
      'created_at': createdAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'questions': questions.map(_questionToJson).toList(),
    };
  }

  static List<QuestionEntity> _parseQuestions(dynamic value) {
    if (value is! List<dynamic>) {
      return const <QuestionEntity>[];
    }

    return value
        .map(
          (json) => QuestionEntityImpl.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  static Map<String, dynamic> _questionToJson(QuestionEntity question) {
    if (question is QuestionEntityImpl) {
      return question.toJson();
    }

    throw Exception('Unsupported question type for JSON serialization');
  }

  static SurveyStatus _mapSurveyStatus(String? value) {
    switch (value) {
      case 'published':
        return SurveyStatus.published;
      case 'closed':
        return SurveyStatus.closed;
      case 'draft':
      default:
        return SurveyStatus.draft;
    }
  }

  static String _surveyStatusToJson(SurveyStatus value) {
    switch (value) {
      case SurveyStatus.draft:
        return 'draft';
      case SurveyStatus.published:
        return 'published';
      case SurveyStatus.closed:
        return 'closed';
    }
  }

  static DateTime? _parseNullableDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.parse(value as String);
  }
}
