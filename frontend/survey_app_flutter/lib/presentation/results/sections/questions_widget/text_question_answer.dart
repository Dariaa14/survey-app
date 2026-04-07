import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget for displaying the answer to a text question in the survey results.
class TextQuestionAnswer extends StatelessWidget {
  /// Constructs a [TextQuestionAnswer] widget.
  const TextQuestionAnswer({
    required this.question,
    required this.comments,
    required this.submittedCount,
    required this.onViewAll,
    super.key,
  });

  /// Text question shown in results.
  final QuestionEntity question;

  /// Text comments submitted for this question.
  final List<AnswerEntity> comments;

  /// Total number of submitted responses for this survey.
  final int submittedCount;

  /// Callback that opens the comments tab filtered by this question.
  final VoidCallback onViewAll;

  String _formatCommentDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '';
    }

    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) {
      return rawDate;
    }

    const monthLabels = <int, String>{
      1: 'ian',
      2: 'feb',
      3: 'mar',
      4: 'apr',
      5: 'mai',
      6: 'iun',
      7: 'iul',
      8: 'aug',
      9: 'sep',
      10: 'oct',
      11: 'nov',
      12: 'dec',
    };

    final month = monthLabels[parsedDate.month] ?? '';
    return '${parsedDate.day} $month ${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final previewComments = comments.take(2).toList();

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
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.resultsTextMeta(
                        comments.length,
                        submittedCount,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                onPressed: onViewAll,
                text: AppStrings.resultsViewAllTextAnswersButton,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (previewComments.isEmpty)
            Text(
              AppStrings.resultsTextAnswersPreviewMock,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              children: List.generate(previewComments.length, (index) {
                final comment = previewComments[index];
                final email = (comment.email ?? '').trim();
                final submittedAt = _formatCommentDate(comment.submittedAt);

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == previewComments.length - 1 ? 0 : 8,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.textValue ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (email.isNotEmpty || submittedAt.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            [
                              email,
                              submittedAt,
                            ].where((value) => value.isNotEmpty).join(' · '),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
