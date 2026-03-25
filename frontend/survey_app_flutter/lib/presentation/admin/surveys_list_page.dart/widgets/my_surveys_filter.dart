import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_inverted_gray_button.dart';
import 'package:survey_app_flutter/shared/custom_inverted_red_button.dart';
import 'package:survey_app_flutter/shared/custom_inverted_secondary_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A filter widget for the "My Surveys" tab in the admin surveys list page.
class MySurveysFilter extends StatelessWidget {
  /// Constructs a [MySurveysFilter].
  const MySurveysFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filterButtons = [
      CustomInvertedGrayButton(
        onPressed: () {},
        text: AppStrings.allFilterButton,
      ),
      CustomInvertedGrayButton(
        onPressed: () {},
        text: AppStrings.draftFilterButton,
      ),
      CustomInvertedSecondaryButton(
        onPressed: () {},
        text: AppStrings.publishedFilterButton,
      ),
      CustomInvertedRedButton(
        onPressed: () {},
        text: AppStrings.closedFilterButton,
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
