import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_builder_action_buttons.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_limit_input_widget.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/required_limit_section.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A section widget for building multiple choice questions in the survey builder.
class MultiChoiceQuestionSection extends StatefulWidget {
  /// Constructs a [MultiChoiceQuestionSection].
  const MultiChoiceQuestionSection({super.key});

  @override
  State<MultiChoiceQuestionSection> createState() =>
      _MultiChoiceQuestionSectionState();
}

class _MultiChoiceQuestionSectionState
    extends State<MultiChoiceQuestionSection> {
  bool _isRequired = false;
  int _maxOptions = 2;

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
            const CustomTextfield(
              hintText: AppStrings.questionTextPlaceholder,
            ),
            const SizedBox(height: 16),
            RequiredLimitSection(
              isRequired: _isRequired,
              onRequiredChanged: ({bool? required}) {
                setState(() {
                  _isRequired = required ?? false;
                });
              },
              limitType: QuestionLimitType.maxOptions,
              onLimitChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.numberOfOptionsLabel(_maxOptions),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {},
              text: '+ ${AppStrings.addOptionButton}',
            ),
            const SizedBox(height: 20),
            QuestionBuilderActionButtons(
              onSave: () {},
            ),
          ],
        );
      },
    );
  }
}
