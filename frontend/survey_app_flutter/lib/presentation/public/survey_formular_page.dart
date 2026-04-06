import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/data/entities_impl/answer_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_bloc.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_event.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_state.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/multi_choice_question.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/text_question.dart';
import 'package:survey_app_flutter/presentation/public/quesion_widgets.dart/unanswered_question_warning.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/already_answered_survey_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/closed_survey_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_states_pages/invalid_survey_page.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page for displaying the survey formular to users.
class SurveyFormularPage extends StatefulWidget {
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

  @override
  State<SurveyFormularPage> createState() => _SurveyFormularPageState();
}

class _SurveyFormularPageState extends State<SurveyFormularPage> {
  final Map<String, Object?> _answers = <String, Object?>{};
  final List<String> _warningMessages = <String>[];

  @override
  void initState() {
    super.initState();

    AppBlocs.publicBloc.add(
      PublicSurveyRequested(slug: widget.slug, token: widget.token),
    );
  }

  void _handleMultipleChoiceChanged(String questionId, Set<int> selected) {
    _answers[questionId] = selected;
  }

  void _handleTextChanged(String questionId, String value) {
    _answers[questionId] = value;
  }

  void _handleSubmit(SurveyEntity survey) {
    final warnings = <String>[];

    for (final question in survey.questions) {
      if (!question.required) {
        continue;
      }

      final answer = _answers[question.id];

      if (question.type == QuestionType.multipleChoice) {
        final selected = answer is Set<int> ? answer : const <int>{};
        if (selected.isEmpty) {
          warnings.add(
            AppStrings.publicRequiredSelectWarning(question.order),
          );
        }
        continue;
      }

      if (question.type == QuestionType.text) {
        final text = answer is String ? answer.trim() : '';
        if (text.isEmpty) {
          warnings.add(
            AppStrings.publicRequiredTextWarning(question.order),
          );
        }
      }
    }

    setState(() {
      _warningMessages
        ..clear()
        ..addAll(warnings);
    });

    // If validation passed, submit the response
    if (warnings.isEmpty) {
      // Convert answers map to List<AnswerEntity>
      final answerEntities = <AnswerEntityImpl>[];

      _answers.forEach((questionId, answerValue) {
        if (answerValue is Set<int>) {
          // Multiple choice: create one AnswerEntity per option selected
          final question = survey.questions.firstWhere(
            (q) => q.id == questionId,
          );
          final options = question.options;

          if (options != null) {
            for (final optionIndex in answerValue) {
              if (optionIndex < options.length) {
                answerEntities.add(
                  AnswerEntityImpl(
                    questionId: questionId,
                    responseId: '', // Placeholder - server will assign
                    id: '', // Placeholder - server will assign
                    optionId: options[optionIndex].id,
                    textValue: null,
                  ),
                );
              }
            }
          }
        } else if (answerValue is String && answerValue.trim().isNotEmpty) {
          // Text answer
          answerEntities.add(
            AnswerEntityImpl(
              questionId: questionId,
              responseId: '', // Placeholder - server will assign
              id: '', // Placeholder - server will assign
              optionId: null,
              textValue: answerValue.trim(),
            ),
          );
        }
      });

      AppBlocs.publicBloc.add(
        PublicResponseSubmitted(
          slug: widget.slug,
          token: widget.token,
          answers: answerEntities,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PublicBloc, PublicState>(
      bloc: AppBlocs.publicBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null) {
          return const InvalidSurveyPage();
        }

        final survey = state.survey;
        if (survey == null) {
          return const InvalidSurveyPage();
        }

        if (state.mockAlreadyAnswered) {
          return const AlreadyAnsweredSurveyPage();
        }

        if (survey.status == SurveyStatus.closed) {
          return const ClosedSurveyPage();
        }

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
                            survey.questions.length,
                            (index) {
                              final question = survey.questions[index];

                              if (question.type ==
                                  QuestionType.multipleChoice) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: MultiChoiceQuestion(
                                    question: question,
                                    onSelectionChanged: (selected) {
                                      _handleMultipleChoiceChanged(
                                        question.id,
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
                                  onTextChanged: (value) {
                                    _handleTextChanged(question.id, value);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        if (_warningMessages.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Column(
                            children: _warningMessages
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
                            onPressed: () => _handleSubmit(survey),
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
