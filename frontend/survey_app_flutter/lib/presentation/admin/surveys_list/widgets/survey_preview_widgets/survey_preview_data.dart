import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview_widgets/survey_preview_status.dart';

/// Data model used by survey preview widgets.
class SurveyPreviewData {
  /// Constructs a [SurveyPreviewData].
  const SurveyPreviewData({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.questionCount,
    required this.createdAt,
    required this.status,
    this.invitationsCount,
    this.submitRate,
  });

  /// Unique survey identifier.
  final int id;

  /// Survey title.
  final String title;

  /// Survey description.
  final String description;

  /// URL slug.
  final String slug;

  /// Number of questions in the survey.
  final int questionCount;

  /// Creation date text.
  final String createdAt;

  /// Survey status.
  final SurveyPreviewStatus status;

  /// Invitations count (used for published surveys).
  final int? invitationsCount;

  /// Submit rate in percentage points (used for published surveys).
  final double? submitRate;
}
