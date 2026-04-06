import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget for displaying the answer to a text question in the survey results.
class TextQuestionAnswer extends StatelessWidget {
  /// Constructs a [TextQuestionAnswer] widget.
  const TextQuestionAnswer({
    required this.question,
    super.key,
  });

  /// Text question shown in results.
  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                      AppStrings.resultsTextMeta(96, 152),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                onPressed: () {},
                text: AppStrings.resultsViewAllTextAnswersButton,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.resultsTextAnswersPreviewMock,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
