import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview_widgets/survey_preview_action_buttons.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview_widgets/survey_preview_status_row.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that displays a preview of a survey in the admin section.
class SurveyPreview extends StatelessWidget {
  /// Constructs a [SurveyPreview].
  const SurveyPreview({required this.survey, super.key});

  /// Survey data displayed by this preview.
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        context.go(
          AppRoutes.adminSurveyEditPath(survey.id.toString()),
          extra: survey,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    survey.title,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SurveyPreviewActionButtons(survey: survey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.surveyPreviewMeta(
                survey.slug,
                1, // survey.questionCount,
                survey.createdAt,
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SurveyPreviewStatusRow(survey: survey),
          ],
        ),
      ),
    );
  }
}
