import 'package:survey_app_flutter/data/entities_impl/option_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/option_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';

/// Concrete implementation of [QuestionEntity] used in data layer.
class QuestionEntityImpl implements QuestionEntity {
  /// Creates a [QuestionEntityImpl].
  const QuestionEntityImpl({
    required this.id,
    required this.surveyId,
    required this.title,
    required this.type,
    required this.required,
    required this.order,
    this.maxLength,
    this.maxSelections,
    this.options,
  });

  /// Builds an instance from backend JSON payload.
  factory QuestionEntityImpl.fromJson(Map<String, dynamic> json) {
    return QuestionEntityImpl(
      id: json['id'] as String,
      surveyId: json['survey_id'] as String,
      title: json['title'] as String,
      type: _mapQuestionType(json['type'] as String?),
      required: json['required'] as bool,
      order: json['order'] as int,
      maxLength: json['max_length'] as int?,
      maxSelections: json['max_selections'] as int?,
      options: _parseOptions(json['options']),
    );
  }

  @override
  final String id;

  @override
  final String surveyId;

  @override
  final String title;

  @override
  final QuestionType type;

  @override
  final bool required;

  @override
  final int order;

  @override
  final int? maxLength;

  @override
  final int? maxSelections;

  @override
  final List<OptionEntity>? options;

  @override
  QuestionEntityImpl copyWith({
    String? id,
    String? surveyId,
    QuestionType? type,
    String? title,
    bool? required,
    int? order,
    int? maxLength,
    int? maxSelections,
    List<OptionEntity>? options,
  }) {
    return QuestionEntityImpl(
      id: id ?? this.id,
      surveyId: surveyId ?? this.surveyId,
      type: type ?? this.type,
      title: title ?? this.title,
      required: required ?? this.required,
      order: order ?? this.order,
      maxLength: maxLength ?? this.maxLength,
      maxSelections: maxSelections ?? this.maxSelections,
      options: options ?? this.options,
    );
  }

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'survey_id': surveyId,
      'title': title,
      'type': _questionTypeToJson(type),
      'required': required,
      'order': order,
      if (maxLength != null) 'max_length': maxLength,
      if (maxSelections != null) 'max_selections': maxSelections,
      'options': options?.map(_optionToJson).toList(),
    };
  }

  static List<OptionEntity> _parseOptions(dynamic value) {
    if (value is! List<dynamic>) {
      return const <OptionEntity>[];
    }

    return value
        .map((json) => OptionEntityImpl.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Map<String, dynamic> _optionToJson(OptionEntity option) {
    if (option is OptionEntityImpl) {
      return option.toJson();
    }

    throw Exception('Unsupported option type for JSON serialization');
  }

  static QuestionType _mapQuestionType(String? value) {
    switch (value) {
      case 'text':
        return QuestionType.text;
      case 'choice':
        return QuestionType.multipleChoice;
      default:
        return QuestionType.text;
    }
  }

  static String _questionTypeToJson(QuestionType value) {
    switch (value) {
      case QuestionType.text:
        return 'text';
      case QuestionType.multipleChoice:
        return 'choice';
    }
  }
}
