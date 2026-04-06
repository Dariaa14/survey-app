import 'package:survey_app_flutter/data/entities_impl/answer_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/response_entity.dart';

class ResponseEntityImpl implements ResponseEntity {
  @override
  final String id;

  @override
  final String surveyId;

  @override
  final String invitationId;

  @override
  final DateTime submittedAt;

  @override
  final List<AnswerEntity> answers;

  /// Constructs a [ResponseEntityImpl] with the given parameters.
  const ResponseEntityImpl({
    required this.id,
    required this.surveyId,
    required this.invitationId,
    required this.submittedAt,
    required this.answers,
  });

  /// Factory method to create a [ResponseEntityImpl] from a JSON map.
  factory ResponseEntityImpl.fromJson(Map<String, dynamic> json) {
    return ResponseEntityImpl(
      id: json['id'] as String,
      surveyId: json['surveyId'] as String,
      invitationId: json['invitationId'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerEntityImpl.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this [ResponseEntityImpl] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surveyId': surveyId,
      'invitationId': invitationId,
      'submittedAt': submittedAt.toIso8601String(),
      'answers': answers.map((e) => (e as AnswerEntityImpl).toJson()).toList(),
    };
  }
}
