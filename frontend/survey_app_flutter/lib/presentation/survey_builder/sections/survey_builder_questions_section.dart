import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/question_builder_page.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_event.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/add_question_dashed_button.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that displays the questions section of the survey builder page.
class SurveyBuilderQuestionsSection extends StatelessWidget {
  /// Constructs a [SurveyBuilderQuestionsSection].
  const SurveyBuilderQuestionsSection({
    required this.questions,
    this.expand = true,
    super.key,
  });

  /// Number of currently added questions.
  final List<QuestionEntity> questions;

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
              '${AppStrings.questionsTitle} (${questions.length})',
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
                  onPressed: () => _showAddQuestionDialog(context),
                  text: '+ ${AppStrings.multiChoiceTab}',
                ),
                CustomButton(
                  onPressed: () =>
                      _showAddQuestionDialog(context, isMultiChoice: false),
                  text: '+ ${AppStrings.freeTextTab}',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...questions.map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionPreview(
              question: q,
              onEdit: () => _showAddQuestionDialog(context, question: q),
            ),
          ),
        ),
        const SizedBox(height: 4),
        AddQuestionDashedButton(
          onTap: () => _showAddQuestionDialog(context),
        ),
      ],
    );

    if (!expand) {
      return content;
    }

    return Expanded(child: content);
  }

  Future<void> _showAddQuestionDialog(
    BuildContext context, {
    bool isMultiChoice = true,
    QuestionEntity? question,
  }) async {
    final newQuestion = await showDialog<QuestionEntity?>(
      context: context,
      builder: (context) => QuestionBuilderPage(
        orderNumber: questions.length + 1,
        initialIsMultiChoiceSelected: isMultiChoice,
        question: question,
      ),
    );

    AppBlocs.questionBuilderBloc.add(QuestionBuilderReset());
    if (newQuestion == null) return;

    if (question != null) {
      /// TODO: add edit question functionality instead of just adding a
      /// new question when editing an existing one
      return;
    }
    AppBlocs.surveyBuilderBloc.add(AddQuestion(newQuestion));
  }
}
