import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/question_builder/question_builder_page.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/add_question_dashed_button.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview_data.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
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
                CustomButton(
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
                CustomButton(
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
        const SizedBox(height: 20),
        ..._mockQuestions().map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionPreview(question: q),
          ),
        ),
        const SizedBox(height: 4),
        AddQuestionDashedButton(
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (context) => const QuestionBuilderPage(
                initialIsMultiChoiceSelected: true,
              ),
            );
          },
        ),
      ],
    );

    if (!expand) {
      return content;
    }

    return Expanded(child: content);
  }

  List<QuestionPreviewData> _mockQuestions() {
    return [
      QuestionPreviewData(
        title: 'Care este culoarea ta preferată?',
        id: 1,
        type: QuestionType.multipleChoice,
        required: true,
      ),
      QuestionPreviewData(
        title: 'Ce părere ai despre produsul nostru?',
        id: 2,
        type: QuestionType.freeText,
      ),
      QuestionPreviewData(
        title: 'Cât de des folosești produsul nostru?',
        id: 3,
        type: QuestionType.multipleChoice,
      ),
    ];
  }
}
