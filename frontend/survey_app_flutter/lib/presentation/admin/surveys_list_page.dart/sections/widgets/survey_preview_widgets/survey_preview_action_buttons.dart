import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_data.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_status.dart';
import 'package:survey_app_flutter/shared/custom_inverted_button.dart';
import 'package:survey_app_flutter/shared/custom_inverted_red_button.dart';
import 'package:survey_app_flutter/shared/custom_inverted_secondary_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Action buttons for the survey preview widget.
class SurveyPreviewActionButtons extends StatelessWidget {
  /// Constructs a [SurveyPreviewActionButtons].
  const SurveyPreviewActionButtons({required this.survey, super.key});

  /// Survey data used to determine visible action buttons.
  final SurveyPreviewData survey;

  List<Widget> _buttonsForStatus() {
    switch (survey.status) {
      case SurveyPreviewStatus.published:
        return [
          CustomInvertedButton(
            onPressed: () {},
            text: AppStrings.surveyResultsButton,
          ),
          CustomInvertedRedButton(
            onPressed: () {},
            text: AppStrings.surveyCloseButton,
          ),
        ];
      case SurveyPreviewStatus.draft:
        return [
          CustomInvertedButton(
            onPressed: () {},
            text: AppStrings.surveyEditButton,
          ),
          CustomInvertedSecondaryButton(
            onPressed: () {},
            text: AppStrings.surveyPublishButton,
          ),
        ];
      case SurveyPreviewStatus.closed:
        return [
          CustomInvertedButton(
            onPressed: () {},
            text: AppStrings.surveyResultsButton,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _buttonsForStatus();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int index = 0; index < buttons.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          buttons[index],
        ],
      ],
    );
  }
}
