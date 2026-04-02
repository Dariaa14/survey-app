import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview_widgets/survey_status_badge.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Row that shows survey status chip and optional status info text.
class SurveyPreviewStatusRow extends StatelessWidget {
  /// Constructs a [SurveyPreviewStatusRow].
  const SurveyPreviewStatusRow({
    required this.survey,
    super.key,
  });

  /// Survey data used to render the chip and optional info.
  final SurveyEntity survey;

  String? _statusInfoText() {
    if (survey.status == SurveyStatus.published) {
      final invitations = survey.invitationCount;
      final submitRate = survey.invitationCount > 0
          ? (survey.submittedCount / survey.invitationCount * 100)
                .toStringAsFixed(0)
          : '0';
      return AppStrings.surveyPublishedInfo(invitations, submitRate);
    }

    if (survey.status == SurveyStatus.draft) {
      return AppStrings.surveyDraftInfo;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusInfoText = _statusInfoText();

    return Row(
      children: [
        SurveyStatusBadge(survey: survey),
        if (statusInfoText != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              statusInfoText,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
