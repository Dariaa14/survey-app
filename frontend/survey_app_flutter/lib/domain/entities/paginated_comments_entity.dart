import 'package:survey_app_flutter/domain/entities/answer_entity.dart';

/// Paginated comments payload returned by survey results comments endpoint.
class PaginatedCommentsEntity {
  /// Creates a paginated comments response.
  const PaginatedCommentsEntity({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalCount,
  });

  /// Current page results.
  final List<AnswerEntity> results;

  /// Current page index (1-based).
  final int page;

  /// Total number of available pages.
  final int totalPages;

  /// Total number of matching comments.
  final int totalCount;
}
