import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_state.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/options_builder.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_builder_action_buttons.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_limit_input_widget.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/required_limit_section.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A section widget for building multiple choice questions
///  in the survey builder.
class MultiChoiceQuestionSection extends StatelessWidget {
  /// Constructs a [MultiChoiceQuestionSection].
  const MultiChoiceQuestionSection({super.key});

  static const int _minOptions = 2;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.questionTextLabel} *',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              hintText: AppStrings.questionTextPlaceholder,
              onChanged: (value) {
                AppBlocs.questionBuilderBloc.add(QuestionTitleChanged(value));
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<QuestionBuilderBloc, QuestionBuilderState>(
              bloc: AppBlocs.questionBuilderBloc,
              buildWhen: (previous, current) =>
                  previous.required != current.required,
              builder: (context, state) {
                return RequiredLimitSection(
                  isRequired: state.required,
                  onRequiredChanged: ({bool? required}) {
                    if (required != null) {
                      AppBlocs.questionBuilderBloc.add(
                        QuestionRequiredChanged(required: required),
                      );
                    }
                  },
                  limitType: QuestionLimitType.maxOptions,
                  onLimitChanged: (value) {
                    final int? maxSelections = int.tryParse(value.trim());
                    AppBlocs.questionBuilderBloc.add(
                      QuestionMaxSelectionsChanged(maxSelections),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.numberOfOptionsLabel(_minOptions),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<QuestionBuilderBloc, QuestionBuilderState>(
              bloc: AppBlocs.questionBuilderBloc,
              buildWhen: (previous, current) =>
                  previous.options != current.options,
              builder: (context, state) {
                return Column(
                  children: [
                    for (final entry in state.options.asMap().entries)
                      OptionsBuilder(
                        key: ValueKey(entry.key),
                        initialValue: entry.value.label,
                        onDelete: () {
                          AppBlocs.questionBuilderBloc.add(
                            QuestionOptionRemoved(entry.key),
                          );
                        },
                        onOptionChanged: (value) {
                          AppBlocs.questionBuilderBloc.add(
                            QuestionOptionChanged(entry.key, value),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {
                AppBlocs.questionBuilderBloc.add(QuestionOptionsAdded(''));
              },
              text: '+ ${AppStrings.addOptionButton}',
            ),
            const SizedBox(height: 20),
            BlocBuilder<QuestionBuilderBloc, QuestionBuilderState>(
              bloc: AppBlocs.questionBuilderBloc,
              buildWhen: (previous, current) =>
                  previous.title != current.title ||
                  previous.maxSelections != current.maxSelections ||
                  previous.options != current.options,
              builder: (context, state) {
                final isTitleValid = state.title.trim().isNotEmpty;
                final isMaxSelectionsValid =
                    state.maxSelections != null && state.maxSelections! > 0;
                final hasMinimumOptions = state.options.length >= _minOptions;
                final hasOnlyNonEmptyOptions = state.options.every(
                  (option) => option.label.trim().isNotEmpty,
                );
                final canSave = isTitleValid &&
                    isMaxSelectionsValid &&
                    hasMinimumOptions &&
                    hasOnlyNonEmptyOptions;

                String? validationMessage;
                if (!hasMinimumOptions) {
                  validationMessage = AppStrings.warningMinimumOptions(
                    _minOptions,
                  );
                } else if (!hasOnlyNonEmptyOptions) {
                  validationMessage =
                      AppStrings.questionBuilderEmptyOptionsMessage;
                } else if (!isTitleValid || !isMaxSelectionsValid) {
                  validationMessage =
                      AppStrings.questionBuilderInvalidFieldsMessage;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (validationMessage != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            validationMessage,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    QuestionBuilderActionButtons(
                      onSave: canSave
                          ? () {
                              Navigator.pop(
                                context,
                                AppBlocs.questionBuilderBloc
                                    .buildQuestionEntity(),
                              );
                            }
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
