import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_state.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_builder_action_buttons.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_limit_input_widget.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/required_limit_section.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A section widget for building free text questions in the survey builder.
class FreeTextQuestionSection extends StatefulWidget {
  /// Constructs a [FreeTextQuestionSection].
  const FreeTextQuestionSection({super.key});

  @override
  State<FreeTextQuestionSection> createState() =>
      _FreeTextQuestionSectionState();
}

class _FreeTextQuestionSectionState extends State<FreeTextQuestionSection> {
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
                    AppBlocs.questionBuilderBloc.add(
                      QuestionRequiredChanged(required: required ?? false),
                    );
                  },
                  limitType: QuestionLimitType.maxCharacters,
                  onLimitChanged: (value) {
                    final int maxCharacters = int.tryParse(value) ?? 0;
                    AppBlocs.questionBuilderBloc.add(
                      QuestionMaxLengthChanged(maxCharacters),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            QuestionBuilderActionButtons(
              onSave: () {
                Navigator.pop(
                  context,
                  AppBlocs.questionBuilderBloc.buildQuestionEntity(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
