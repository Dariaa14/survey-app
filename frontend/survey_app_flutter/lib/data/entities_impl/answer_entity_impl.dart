import 'package:survey_app_flutter/domain/entities/answer_entity.dart';

/// Implementation of the [AnswerEntity] interface, representing an answer to a survey question.
class AnswerEntityImpl implements AnswerEntity {
  @override
  final String questionId;

  @override
  final String responseId;

  @override
  final String id;

  @override
  final String? textValue;

  @override
  final String? optionId;

  /// Constructs an [AnswerEntityImpl] with the given parameters.
  const AnswerEntityImpl({
    required this.questionId,
    required this.responseId,
    required this.id,
    this.textValue,
    this.optionId,
  });

  /// Factory method to create an [AnswerEntityImpl] from a JSON map.
  factory AnswerEntityImpl.fromJson(Map<String, dynamic> json) {
    return AnswerEntityImpl(
      questionId: json['questionId'] as String,
      responseId: json['responseId'] as String,
      id: json['id'] as String,
      textValue: json['textValue'] as String?,
      optionId: json['optionId'] as String?,
    );
  }

  /// Converts this [AnswerEntityImpl] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'responseId': responseId,
      'id': id,
      'textValue': textValue,
      'optionId': optionId,
    };
  }
}
