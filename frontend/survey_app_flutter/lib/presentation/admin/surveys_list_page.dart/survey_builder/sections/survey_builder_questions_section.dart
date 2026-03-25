import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/question_builder_page.dart';
import 'package:survey_app_flutter/shared/custom_inverted_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that displays the questions section of the survey builder page.
class SurveyBuilderQuestionsSection extends StatelessWidget {
  /// Constructs a [SurveyBuilderQuestionsSection].
  const SurveyBuilderQuestionsSection({
    this.questionsCount = 0,
    this.expand = true,
    super.key,
  });

  /// Number of currently added questions.
  final int questionsCount;

  /// Whether the section should occupy remaining horizontal space in a Row.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppStrings.questionsTitle} ($questionsCount)',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: [
                CustomInvertedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => const QuestionBuilderPage(
                        initialIsMultiChoiceSelected: true,
                      ),
                    );
                  },
                  text: '+ ${AppStrings.multiChoiceTab}',
                ),
                CustomInvertedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => const QuestionBuilderPage(
                        initialIsMultiChoiceSelected: false,
                      ),
                    );
                  },
                  text: '+ ${AppStrings.freeTextTab}',
                ),
              ],
            ),
          ],
        ),
      ],
    );

    if (!expand) {
      return content;
    }

    return Expanded(child: content);
  }
}
