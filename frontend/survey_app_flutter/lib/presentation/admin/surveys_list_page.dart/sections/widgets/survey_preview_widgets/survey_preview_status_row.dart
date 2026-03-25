import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_data.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_status.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// Row that shows survey status chip and optional status info text.
class SurveyPreviewStatusRow extends StatelessWidget {
  /// Constructs a [SurveyPreviewStatusRow].
  const SurveyPreviewStatusRow({
    required this.survey,
    super.key,
  });

  /// Survey data used to render the chip and optional info.
  final SurveyPreviewData survey;

  Color _statusBackground(ColorScheme colorScheme) {
    switch (survey.status) {
      case SurveyPreviewStatus.published:
        return colorScheme.secondaryContainer;
      case SurveyPreviewStatus.draft:
        return colorScheme.surfaceContainer;
      case SurveyPreviewStatus.closed:
        return redContainer;
    }
  }

  Color _statusDotColor(ColorScheme colorScheme) {
    switch (survey.status) {
      case SurveyPreviewStatus.published:
        return colorScheme.secondary;
      case SurveyPreviewStatus.draft:
        return colorScheme.onSurfaceVariant;
      case SurveyPreviewStatus.closed:
        return colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (survey.status) {
      case SurveyPreviewStatus.published:
        return AppStrings.publishedFilterButton;
      case SurveyPreviewStatus.draft:
        return AppStrings.draftFilterButton;
      case SurveyPreviewStatus.closed:
        return AppStrings.closedFilterButton;
    }
  }

  String? _statusInfoText() {
    if (survey.status == SurveyPreviewStatus.published) {
      final invitations = survey.invitationsCount ?? 0;
      final submitRate = survey.submitRate?.toStringAsFixed(0) ?? '0';
      return AppStrings.surveyPublishedInfo(invitations, submitRate);
    }

    if (survey.status == SurveyPreviewStatus.draft) {
      return AppStrings.surveyDraftInfo;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusDotColor = _statusDotColor(colorScheme);
    final statusInfoText = _statusInfoText();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: _statusBackground(colorScheme),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusDotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _statusLabel().toLowerCase(),
                style: textTheme.bodySmall?.copyWith(
                  color: statusDotColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
