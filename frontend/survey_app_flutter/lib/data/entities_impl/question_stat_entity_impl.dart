import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';

/// Concrete implementation of [QuestionStatEntity] that can be instantiated
class QuestionStatEntityImpl implements QuestionStatEntity {
  @override
  final String questionId;

  @override
  final String questionText;

  @override
  final String? optionId;

  @override
  final String? optionText;

  @override
  final int count;

  @override
  final double percentage;

  /// Constructor for creating an instance of [QuestionStatEntityImpl].
  const QuestionStatEntityImpl({
    required this.questionId,
    required this.questionText,
    required this.optionId,
    required this.optionText,
    required this.count,
    required this.percentage,
  });

  /// Factory constructor to create an instance from JSON data.
  factory QuestionStatEntityImpl.fromJson(Map<String, dynamic> json) {
    return QuestionStatEntityImpl(
      questionId: (json['question_id'] ?? '').toString(),
      questionText: (json['question_text'] ?? '').toString(),
      optionId: json['option_id']?.toString(),
      optionText: json['option_text']?.toString(),
      count: _toInt(json['count']),
      percentage: _toDouble(json['percentage']),
    );
  }

  /// Converts the entity back to JSON format, useful for debugging or
  /// serialization.
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_text': questionText,
      'option_id': optionId,
      'option_text': optionText,
      'count': count,
      'percentage': percentage,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}
