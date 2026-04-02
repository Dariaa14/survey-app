import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// Shared status badge used across survey-related views.
class SurveyStatusBadge extends StatelessWidget {
  /// Constructs a [SurveyStatusBadge].
  const SurveyStatusBadge({required this.survey, super.key});

  /// Survey data used to render the badge.
  final SurveyEntity survey;

  Color _statusBackground(ColorScheme colorScheme) {
    switch (survey.status) {
      case SurveyStatus.published:
        return colorScheme.secondaryContainer;
      case SurveyStatus.draft:
        return colorScheme.surfaceContainer;
      case SurveyStatus.closed:
        return redContainer;
    }
  }

  Color _statusDotColor(ColorScheme colorScheme) {
    switch (survey.status) {
      case SurveyStatus.published:
        return colorScheme.secondary;
      case SurveyStatus.draft:
        return colorScheme.onSurfaceVariant;
      case SurveyStatus.closed:
        return colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (survey.status) {
      case SurveyStatus.published:
        return AppStrings.publishedFilterButton;
      case SurveyStatus.draft:
        return AppStrings.draftFilterButton;
      case SurveyStatus.closed:
        return AppStrings.closedFilterButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final statusDotColor = _statusDotColor(colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    );
  }
}
