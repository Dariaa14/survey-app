import 'package:survey_app_flutter/domain/entities/answer_entity.dart';

/// Entity representing a survey response, containing respondent's answers
/// and metadata.
abstract class ResponseEntity {
  /// Unique identifier for the response.
  String get id;

  /// Identifier of the survey this response belongs to.
  String get surveyId;

  /// Identifier of the respondent.
  String get invitationId;

  /// Timestamp when the response was submitted.
  DateTime get submittedAt;

  /// List of answers provided by the respondent.
  List<AnswerEntity> get answers;
}
