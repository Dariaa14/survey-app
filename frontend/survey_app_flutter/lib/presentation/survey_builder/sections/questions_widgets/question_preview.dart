import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_event.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview_badge.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A preview widget for a question in the survey builder.
class QuestionPreview extends StatelessWidget {
  /// Constructs a [QuestionPreview].
  const QuestionPreview({
    required this.question,
    required this.onEdit,

    super.key,
  });

  /// Title shown for the previewed question.
  final QuestionEntity question;

  /// Callback when the edit button is pressed.
  final VoidCallback onEdit;

  String _maxLimitText() {
    if (question.type == QuestionType.multipleChoice) {
      return AppStrings.questionPreviewMaxSelections(
        question.maxSelections ?? 0,
      );
    }

    return AppStrings.questionPreviewMaxCharacters(question.maxLength ?? 0);
  }

  String _optionsPreviewText() {
    final options = question.options;
    if (options == null || options.isEmpty) {
      return AppStrings.questionPreviewOptions(const <String>[]);
    }

    final labels = options
        .map((option) => option.label.trim())
        .where((label) => label.isNotEmpty)
        .toList();

    if (labels.isEmpty) {
      return AppStrings.questionPreviewOptions(const <String>[]);
    }

    return AppStrings.questionPreviewOptions(labels);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.drag_indicator,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    QuestionPreviewBadge.forQuestionType(question.type),
                    const SizedBox(width: 8),
                    QuestionPreviewBadge.forRequirement(
                      isRequired: question.required,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _maxLimitText(),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (question.type == QuestionType.multipleChoice) ...[
                  const SizedBox(height: 8),
                  Text(
                    _optionsPreviewText(),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onPressed: onEdit,
                text: AppStrings.questionPreviewEditButton,
                variant: CustomColorVariant.gray,
              ),
              const SizedBox(width: 8),
              CustomButton(
                onPressed: () {
                  AppBlocs.surveyBuilderBloc.add(
                    RemoveQuestion(question.order),
                  );
                },
                variant: CustomColorVariant.gray,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Icon(Icons.delete, color: colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
