import 'package:survey_app_flutter/domain/entities/option_entity.dart';

/// Concrete implementation of [OptionEntity] used in data layer.
class OptionEntityImpl implements OptionEntity {
  /// Creates an [OptionEntityImpl].
  const OptionEntityImpl({
    required this.id,
    required this.questionId,
    required this.label,
    required this.order,
  });

  /// Builds an instance from backend JSON payload.
  factory OptionEntityImpl.fromJson(Map<String, dynamic> json) {
    return OptionEntityImpl(
      id: json['id'] as String,
      questionId: json['question_id'] as String,
      label: json['label'] as String,
      order: json['order'] as int,
    );
  }

  @override
  final String id;

  @override
  final String questionId;

  @override
  final String label;

  @override
  final int order;

  /// Serializes this entity to backend-compatible JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'label': label,
      'order': order,
    };
  }
}
