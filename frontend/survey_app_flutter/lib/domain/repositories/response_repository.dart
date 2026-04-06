import 'package:survey_app_flutter/domain/entities/answer_entity.dart';

/// Repository interface for managing survey responses.
abstract class ResponseRepository {
  /// Submits survey response answers for a given survey.
  ///
  /// Parameters:
  ///   - [slug]: The survey slug identifier
  ///   - [token]: Authorization token for the invitation
  ///   - [answers]: List of answer entities containing question and response data
  ///
  /// Throws [Exception] if submission fails
  Future<void> submitSurveyResponse({
    required String slug,
    required String token,
    required List<AnswerEntity> answers,
  });
}
