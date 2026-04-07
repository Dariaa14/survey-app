import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';

/// Concrete implementation of [ResultsSummaryEntity] that can be instantiated.
class ResultsSummaryEntityImpl implements ResultsSummaryEntity {
  @override
  final int invited;

  @override
  final int sent;

  @override
  final int emailOpened;

  @override
  final int surveyOpened;

  @override
  final int submitted;

  @override
  final int bounced;

  /// Constructor for creating an instance of [ResultsSummaryEntityImpl].
  const ResultsSummaryEntityImpl({
    required this.invited,
    required this.sent,
    required this.emailOpened,
    required this.surveyOpened,
    required this.submitted,
    required this.bounced,
  });

  /// Factory constructor to create an instance from JSON data.
  factory ResultsSummaryEntityImpl.fromJson(Map<String, dynamic> json) {
    return ResultsSummaryEntityImpl(
      invited: _toInt(json['invited']),
      sent: _toInt(json['sent']),
      emailOpened: _toInt(json['email_opened']),
      surveyOpened: _toInt(json['survey_opened']),
      submitted: _toInt(json['submitted']),
      bounced: _toInt(json['bounced']),
    );
  }

  /// Converts the entity back to JSON format, useful for debugging or serialization.
  Map<String, dynamic> toJson() {
    return {
      'invited': invited,
      'sent': sent,
      'email_opened': emailOpened,
      'survey_opened': surveyOpened,
      'submitted': submitted,
      'bounced': bounced,
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
}
