import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_bloc.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_state.dart';
import 'package:survey_app_flutter/presentation/results/sections/questions_widget/multi_choice_question_answer.dart';
import 'package:survey_app_flutter/presentation/results/sections/questions_widget/text_question_answer.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Section widget for displaying survey questions in the results page.
class ResultsQuestionsSection extends StatelessWidget {
  /// Constructs a [ResultsQuestionsSection].
  const ResultsQuestionsSection({
    required this.survey,
    super.key,
  });

  /// Survey for which question results are shown.
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final questions = survey.questions;

    if (questions.isEmpty) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Text(
        AppStrings.resultsNoQuestions,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        final stats = state.questionStats;
        final summary = state.summary;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(questions.length, (index) {
            final question = questions[index];
            final widget = question.type == QuestionType.multipleChoice
                ? MultiChoiceQuestionAnswer(
                    question: question,
                    stats: stats,
                    summary: summary,
                  )
                : TextQuestionAnswer(question: question);

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == questions.length - 1 ? 0 : 16,
              ),
              child: widget,
            );
          }),
        );
      },
    );
  }
}
