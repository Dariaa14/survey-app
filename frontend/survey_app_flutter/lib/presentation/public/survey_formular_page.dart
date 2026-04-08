import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/data/entities_impl/answer_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_bloc.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_event.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_state.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/multi_choice_question.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/text_question.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/unanswered_question_warning.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/already_answered_survey_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/closed_survey_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/invalid_survey_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/registered_answer_page.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page for displaying the survey formular to users.
class SurveyFormularPage extends StatelessWidget {
  /// Constructs a [SurveyFormularPage].
  const SurveyFormularPage({
    required this.slug,
    required this.token,
    super.key,
  });

  /// Survey slug from route path.
  final String slug;

  /// Invitation token from route query parameter.
  final String token;

  void _handleMultipleChoiceChanged(
    QuestionEntity question,
    Set<int> selected,
  ) {
    if (selected.isEmpty) {
      AppBlocs.publicBloc.add(PublicAnswersRemoved(questionId: question.id));
      return;
    }

    final options = question.options;
    if (options == null || options.isEmpty) {
      AppBlocs.publicBloc.add(PublicAnswersRemoved(questionId: question.id));
      return;
    }

    final answers = <AnswerEntity>[];
    for (final optionIndex in selected) {
      if (optionIndex >= 0 && optionIndex < options.length) {
        answers.add(
          AnswerEntityImpl(
            questionId: question.id,
            responseId: '',
            id: '',
            optionId: options[optionIndex].id,
          ),
        );
      }
    }

    if (answers.isEmpty) {
      AppBlocs.publicBloc.add(PublicAnswersRemoved(questionId: question.id));
      return;
    }

    AppBlocs.publicBloc.add(PublicAnswerAdded(answers: answers));
  }

  void _handleTextChanged(QuestionEntity question, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      AppBlocs.publicBloc.add(PublicAnswersRemoved(questionId: question.id));
      return;
    }

    AppBlocs.publicBloc.add(
      PublicAnswerAdded(
        answers: [
          AnswerEntityImpl(
            questionId: question.id,
            responseId: '',
            id: '',
            textValue: trimmed,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PublicBloc, PublicState>(
      bloc: AppBlocs.publicBloc,
      builder: (context, state) {
        if (!state.isLoading &&
            state.survey == null &&
            state.errorMessage == null) {
          AppBlocs.publicBloc.add(
            PublicSurveyRequested(slug: slug, token: token),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isSubmitted) {
          return const RegisteredAnswerPage();
        }

        // Check error message to determine which state page to show
        if (state.errorMessage != null) {
          if (state.errorMessage == 'CLOSED') {
            return const ClosedSurveyPage();
          } else if (state.errorMessage == 'ALREADY_SUBMITTED') {
            return const AlreadyAnsweredSurveyPage();
          } else {
            // INVALID or any other error
            return const InvalidSurveyPage();
          }
        }

        final survey = state.survey;
        if (survey == null) {
          return const InvalidSurveyPage();
        }

        final questions = [...survey.questions]
          ..sort((left, right) => left.order.compareTo(right.order));

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 14),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          survey.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          survey.description ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        Column(
                          children: List.generate(
                            questions.length,
                            (index) {
                              final question = questions[index];

                              if (question.type ==
                                  QuestionType.multipleChoice) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: MultiChoiceQuestion(
                                    question: question,
                                    selectedIndexes: state
                                        .getAnswersForQuestion(question.id)
                                        .map((a) => a.optionId)
                                        .whereType<String>()
                                        .map((optionId) {
                                          final options =
                                              question.options ?? const [];
                                          return options.indexWhere(
                                            (o) => o.id == optionId,
                                          );
                                        })
                                        .where((index) => index >= 0)
                                        .toSet(),
                                    onSelectionChanged: (selected) {
                                      _handleMultipleChoiceChanged(
                                        question,
                                        selected,
                                      );
                                    },
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: TextQuestion(
                                  question: question,
                                  initialText:
                                      state
                                          .getAnswersForQuestion(question.id)
                                          .map((a) => a.textValue)
                                          .whereType<String>()
                                          .cast<String?>()
                                          .firstWhere(
                                            (value) =>
                                                value != null &&
                                                value.trim().isNotEmpty,
                                            orElse: () => '',
                                          ) ??
                                      '',
                                  onTextChanged: (value) {
                                    _handleTextChanged(question, value);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        if (state.warningMessages.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Column(
                            children: state.warningMessages
                                .map(
                                  (message) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: UnansweredQuestionWarning(
                                      message: message,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: () {
                              AppBlocs.publicBloc.add(
                                PublicResponseSubmitted(
                                  slug: slug,
                                  token: token,
                                ),
                              );
                            },
                            text: AppStrings.publicSubmitAnswersButton,
                            variant: CustomColorVariant.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
