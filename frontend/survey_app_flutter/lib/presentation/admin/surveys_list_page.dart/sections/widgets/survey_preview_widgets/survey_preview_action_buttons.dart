import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_data.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_status.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Action buttons for the survey preview widget.
class SurveyPreviewActionButtons extends StatelessWidget {
  /// Constructs a [SurveyPreviewActionButtons].
  const SurveyPreviewActionButtons({required this.survey, super.key});

  /// Survey data used to determine visible action buttons.
  final SurveyPreviewData survey;

  Future<void> _showCloseSurveyDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(AppStrings.surveyCloseConfirmMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.noOption),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.yesOption),
          ),
        ],
      ),
    );
  }

  List<Widget> _buttonsForStatus(BuildContext context) {
    switch (survey.status) {
      case SurveyPreviewStatus.published:
        return [
          CustomButton(
            onPressed: () {},
            text: AppStrings.surveyResultsButton,
          ),
          CustomButton(
            onPressed: () {
              _showCloseSurveyDialog(context);
            },
            text: AppStrings.surveyCloseButton,
            variant: CustomColorVariant.invertedRed,
          ),
        ];
      case SurveyPreviewStatus.draft:
        return [
          CustomButton(
            onPressed: () {
              context.go(
                AppRoutes.adminSurveyEditPath(survey.id.toString()),
                extra: survey,
              );
            },
            text: AppStrings.surveyEditButton,
          ),
          CustomButton(
            onPressed: () {},
            text: AppStrings.surveyPublishButton,
            variant: CustomColorVariant.invertedSecondary,
          ),
        ];
      case SurveyPreviewStatus.closed:
        return [
          CustomButton(
            onPressed: () {},
            text: AppStrings.surveyResultsButton,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _buttonsForStatus(context);

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
