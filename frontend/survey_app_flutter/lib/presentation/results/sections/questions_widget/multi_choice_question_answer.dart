import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget for displaying answers to multiple-choice questions in the survey results.
class MultiChoiceQuestionAnswer extends StatelessWidget {
  /// Constructs a [MultiChoiceQuestionAnswer] widget.
  const MultiChoiceQuestionAnswer({
    required this.question,
    required this.stats,
    required this.summary,
    super.key,
  });

  /// Multiple-choice question shown in results.
  final QuestionEntity question;

  /// All question statistics from the API.
  final List<QuestionStatEntity> stats;

  /// Summary data with total respondents.
  final ResultsSummaryEntity? summary;

  List<_OptionMetric> _buildOptionMetrics() {
    final options = question.options ?? const [];
    if (options.isEmpty) {
      return const [];
    }

    // Filter stats to get only the ones for this question
    final questionStats = stats
        .where((stat) => stat.questionId == question.id)
        .toList();

    if (questionStats.isEmpty) {
      // Fallback: create empty metrics for all options
      return options
          .map(
            (option) => _OptionMetric(
              label: option.label,
              percent: 0.0,
              count: 0,
            ),
          )
          .toList();
    }

    final statsByOptionId = <String, QuestionStatEntity>{
      for (final stat in questionStats)
        if (stat.optionId != null) stat.optionId!: stat,
    };

    // Match each option with its stats.
    return options.map((option) {
      final optionStat = statsByOptionId[option.id];

      return _OptionMetric(
        label: option.label,
        percent: optionStat?.percentage ?? 0.0,
        count: optionStat?.count ?? 0,
      );
    }).toList();
  }

  int _getRespondentsForQuestion() {
    // Get the total submitted responses
    return summary?.submitted ?? 0;
  }

  int _getInvitedForQuestion() {
    // Get the total invited
    return summary?.invited ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final optionMetrics = _buildOptionMetrics();
    final respondentsForQuestion = _getRespondentsForQuestion();
    final invitedForQuestion = _getInvitedForQuestion();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.publicQuestionTitle(
                        question.order,
                        question.title,
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.resultsMultiChoiceMeta(
                        question.maxSelections ?? 1,
                        respondentsForQuestion,
                        invitedForQuestion,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: colorScheme.tertiary),
                ),
                child: Text(
                  AppStrings.multiChoiceTab.toLowerCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              border: Border(
                left: BorderSide(
                  color: colorScheme.primary,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              AppStrings.resultsMultiChoicePercentageWarning(
                respondentsForQuestion,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (optionMetrics.isNotEmpty) ...[
            const SizedBox(height: 14),
            Column(
              children: List.generate(optionMetrics.length, (index) {
                final metric = optionMetrics[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == optionMetrics.length - 1 ? 0 : 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          metric.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final fillRatio = (metric.percent / 100).clamp(
                                0.0,
                                1.0,
                              );
                              final fillWidth =
                                  constraints.maxWidth * fillRatio;

                              return SizedBox(
                                height: 8,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ColoredBox(
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.25),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      width: fillWidth,
                                      child: ColoredBox(
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 52,
                        child: Text(
                          AppStrings.resultsPercent(metric.percent),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 44,
                        child: Text(
                          AppStrings.resultsOptionCount(metric.count),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionMetric {
  const _OptionMetric({
    required this.label,
    required this.percent,
    required this.count,
  });

  final String label;
  final double percent;
  final int count;
}
