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

  @override
  final String? email;

  @override
  final String? submittedAt;

  @override
  final int? page;

  /// Constructs an [AnswerEntityImpl] with the given parameters.
  const AnswerEntityImpl({
    required this.questionId,
    required this.responseId,
    required this.id,
    this.textValue,
    this.optionId,
    this.email,
    this.submittedAt,
    this.page,
  });

  /// Factory method to create an [AnswerEntityImpl] from a JSON map.
  factory AnswerEntityImpl.fromJson(Map<String, dynamic> json) {
    return AnswerEntityImpl(
      questionId: json['question_id'] as String,
      responseId: json['response_id'] as String,
      id: json['id'] as String,
      textValue: json['text_value'] as String?,
      optionId: json['option_id'] as String?,
      email: json['email'] as String?,
      submittedAt: json['submitted_at'] as String?,
      page: json['page'] as int?,
    );
  }

  /// Converts this [AnswerEntityImpl] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      if (responseId.isNotEmpty) 'response_id': responseId,
      if (id.isNotEmpty) 'id': id,
      if ((textValue ?? '').trim().isNotEmpty) 'text_value': textValue!.trim(),
      if ((optionId ?? '').isNotEmpty) 'option_id': optionId,
      if ((email ?? '').trim().isNotEmpty) 'email': email!.trim(),
      if ((submittedAt ?? '').trim().isNotEmpty) 'submitted_at': submittedAt,
      if (page != null) 'page': page,
    };
  }
}
