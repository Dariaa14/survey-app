import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_builder_action_buttons.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_limit_input_widget.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/required_limit_section.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
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
  bool _isRequired = false;

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
              limitType: QuestionLimitType.maxCharacters,
              onLimitChanged: (value) {},
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
