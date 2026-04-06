import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';

/// Use case for handling survey response submission operations.
class ResponseUseCase {
  final ResponseRepository _responseRepository;

  /// Constructs a [ResponseUseCase] with the given [ResponseRepository].
  ResponseUseCase(ResponseRepository responseRepository)
    : _responseRepository = responseRepository;

  /// Submits a survey response with the provided answers.
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
  }) async {
    return _responseRepository.submitSurveyResponse(
      slug: slug,
      token: token,
      answers: answers,
    );
  }
}
