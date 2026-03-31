import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_state.dart';
import 'package:survey_app_flutter/presentation/question_builder/free_text_question_section.dart';
import 'package:survey_app_flutter/presentation/question_builder/multi_choice_question_section.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A page for building and editing surveys in the admin section.
class QuestionBuilderPage extends StatelessWidget {
  /// Constructs a [QuestionBuilderPage].
  const QuestionBuilderPage({
    required this.orderNumber,
    this.initialIsMultiChoiceSelected = true,
    super.key,
  });

  /// Initial tab selection when opening the modal.
  final bool initialIsMultiChoiceSelected;

  /// Order number of the question being edited, used for display purposes.
  final int orderNumber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final maxDialogHeight = MediaQuery.sizeOf(context).height * 0.9;

    return Dialog(
      backgroundColor: colorScheme.surfaceContainerLow,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 720, maxHeight: maxDialogHeight),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<QuestionBuilderBloc, QuestionBuilderState>(
            bloc: AppBlocs.questionBuilderBloc
              ..add(
                QuestionTypeChanged(
                  initialIsMultiChoiceSelected
                      ? QuestionType.multipleChoice
                      : QuestionType.text,
                ),
              )
              ..add(QuestionOrderChanged(orderNumber)),
            buildWhen: (previous, current) => previous.type != current.type,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.editQuestionTitle,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (state.type == QuestionType.multipleChoice)
                        CustomButton(
                          onPressed: () {
                            AppBlocs.questionBuilderBloc.add(
                              QuestionTypeChanged(QuestionType.multipleChoice),
                            );
                          },
                          text: AppStrings.multiChoiceTab,
                          variant: CustomColorVariant.primary,
                        )
                      else
                        CustomButton(
                          onPressed: () {
                            AppBlocs.questionBuilderBloc.add(
                              QuestionTypeChanged(QuestionType.multipleChoice),
                            );
                          },
                          text: AppStrings.multiChoiceTab,
                        ),
                      if (state.type == QuestionType.text)
                        CustomButton(
                          onPressed: () {
                            AppBlocs.questionBuilderBloc.add(
                              QuestionTypeChanged(QuestionType.text),
                            );
                          },
                          text: AppStrings.freeTextTab,
                          variant: CustomColorVariant.primary,
                        )
                      else
                        CustomButton(
                          onPressed: () {
                            AppBlocs.questionBuilderBloc.add(
                              QuestionTypeChanged(QuestionType.text),
                            );
                          },
                          text: AppStrings.freeTextTab,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: state.type == QuestionType.multipleChoice
                            ? const MultiChoiceQuestionSection()
                            : const FreeTextQuestionSection(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
