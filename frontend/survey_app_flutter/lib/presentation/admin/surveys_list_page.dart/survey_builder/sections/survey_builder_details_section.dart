import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that displays the details section of the survey builder page.
class SurveyBuilderDetailsSection extends StatelessWidget {
  /// Constructs a [SurveyBuilderDetailsSection].
  const SurveyBuilderDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.surveyDetailsTitle.toUpperCase(),
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.surveyTitleLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        const CustomTextfield(
          hintText: AppStrings.surveyTitlePlaceholder,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.surveyDescriptionLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        const CustomTextfield(
          hintText: AppStrings.surveyDescriptionPlaceholder,
          minLines: 3,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.surveySlugLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextfield(
          hintText: AppStrings.surveySlugPlaceholder,
          textColor: colorScheme.secondary,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.autoGenerateSlugHelperText,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        Divider(color: colorScheme.onSurfaceVariant),
        const SizedBox(height: 20),
        Text(
          AppStrings.actionsTitle.toUpperCase(),
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {},
            text: '💾   ${AppStrings.saveSurveyButton}',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {},
            text: '🚀   ${AppStrings.publishSurveyButton}',
            variant: CustomButtonVariant.primary,
          ),
        ),
      ],
    );
  }
}
