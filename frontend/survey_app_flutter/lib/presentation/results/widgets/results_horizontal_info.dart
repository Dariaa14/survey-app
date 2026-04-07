import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget that displays horizontal information in the results page.
class ResultsHorizontalInfo extends StatelessWidget {
  /// Constructs a [ResultsHorizontalInfo].
  const ResultsHorizontalInfo({
    required this.summary,
    super.key,
  });

  /// Summary data containing invitation/response counts.
  /// If null, mock data is displayed as a placeholder.
  final ResultsSummaryEntity? summary;

  _BounceCompletionStats _buildBounceCompletionStats() {
    final bounced = summary?.bounced ?? 0;
    final completionRate = summary != null && summary!.surveyOpened > 0
        ? (summary!.submitted / summary!.surveyOpened) * 100
        : 0.0;

    return _BounceCompletionStats(
      bounced: bounced,
      completionRate: completionRate,
    );
  }

  List<_MetricInfo> _buildMetrics() {
    final invited = summary?.invited ?? 0;
    final sent = summary?.sent ?? 0;
    final emailOpened = summary?.emailOpened ?? 0;
    final surveyOpened = summary?.surveyOpened ?? 0;
    final submitted = summary?.submitted ?? 0;
    final bounced = summary?.bounced ?? 0;

    final sentPercentage = invited > 0 ? (sent / invited) * 100 : 0.0;
    final emailOpenPercentage = sent > 0 ? (emailOpened / invited) * 100 : 0.0;
    final surveyOpenPercentage = emailOpened > 0
        ? (surveyOpened / invited) * 100
        : 0.0;
    final submittedPercentage = surveyOpened > 0
        ? (submitted / invited) * 100
        : 0.0;
    final bouncedPercentage = invited > 0 ? (bounced / invited) * 100 : 0.0;

    return [
      _MetricInfo(label: AppStrings.resultsInvitedLabel, value: invited),
      _MetricInfo(
        label: AppStrings.resultsSentLabel,
        value: sent,
        percentage: sentPercentage,
      ),
      _MetricInfo(
        label: AppStrings.resultsEmailOpenLabel,
        value: emailOpened,
        percentage: emailOpenPercentage,
      ),
      _MetricInfo(
        label: AppStrings.resultsSurveyOpenLabel,
        value: surveyOpened,
        percentage: surveyOpenPercentage,
      ),
      _MetricInfo(
        label: AppStrings.resultsSubmittedLabel,
        value: submitted,
        percentage: submittedPercentage,
      ),
      _MetricInfo(
        label: 'Bounce',
        value: bounced,
        percentage: bouncedPercentage,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final metrics = _buildMetrics();

    final segmentColors = <Color>[
      colorScheme.tertiaryContainer,
      colorScheme.tertiary,
      colorScheme.secondary,
      colorScheme.primary,
      colorScheme.error,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 7,
          child: Row(
            children: [
              for (final color in segmentColors)
                Expanded(
                  child: Container(color: color),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: metrics
              .map(
                (metric) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${metric.value}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        metric.label.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (metric.percentage != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.resultsPercent(metric.percentage!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.resultsBounceAndCompletion(
            _buildBounceCompletionStats().bounced,
            _buildBounceCompletionStats().completionRate,
          ),
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MetricInfo {
  const _MetricInfo({
    required this.label,
    required this.value,
    this.percentage,
  });

  final String label;
  final int value;
  final double? percentage;
}

class _BounceCompletionStats {
  const _BounceCompletionStats({
    required this.bounced,
    required this.completionRate,
  });

  final int bounced;
  final double completionRate;
}
