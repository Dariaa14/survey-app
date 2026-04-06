import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget that displays horizontal information in the results page.
class ResultsHorizontalInfo extends StatelessWidget {
  /// Constructs a [ResultsHorizontalInfo].
  const ResultsHorizontalInfo({super.key});

  static const List<_MetricInfo> _mockMetrics = [
    _MetricInfo(label: AppStrings.resultsInvitedLabel, value: 1200),
    _MetricInfo(
      label: AppStrings.resultsSentLabel,
      value: 980,
      percentage: 81.7,
    ),
    _MetricInfo(
      label: AppStrings.resultsEmailOpenLabel,
      value: 640,
      percentage: 65.3,
    ),
    _MetricInfo(
      label: AppStrings.resultsSurveyOpenLabel,
      value: 430,
      percentage: 67.2,
    ),
    _MetricInfo(
      label: AppStrings.resultsSubmittedLabel,
      value: 210,
      percentage: 48.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          children: _mockMetrics
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
