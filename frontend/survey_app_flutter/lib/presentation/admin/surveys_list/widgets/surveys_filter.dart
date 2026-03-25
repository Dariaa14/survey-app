import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A filter widget for the "My Surveys" tab in the admin surveys list page.
class SurveysFilter extends StatelessWidget {
  /// Constructs a [SurveysFilter].
  const SurveysFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filterButtons = [
      CustomButton(
        onPressed: () {},
        text: AppStrings.allFilterButton,
        variant: CustomColorVariant.gray,
      ),
      CustomButton(
        onPressed: () {},
        text: AppStrings.draftFilterButton,
        variant: CustomColorVariant.gray,
      ),
      CustomButton(
        onPressed: () {},
        text: AppStrings.publishedFilterButton,
        variant: CustomColorVariant.invertedSecondary,
      ),
      CustomButton(
        onPressed: () {},
        text: AppStrings.closedFilterButton,
        variant: CustomColorVariant.invertedRed,
      ),
    ];

    return Row(
      children: [
        Text(
          AppStrings.mySurveysTitle,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 12,
            runSpacing: 12,
            children: filterButtons,
          ),
        ),
      ],
    );
  }
}
