import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/widgets/max_options_widget.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/widgets/required_checkbox.dart';
import 'package:survey_app_flutter/shared/custom_inverted_button.dart';
import 'package:survey_app_flutter/shared/custom_primary_button.dart';
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
        final isCompact = constraints.maxWidth < 560;

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
            if (isCompact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequiredCheckbox(
                    isRequired: _isRequired,
                    onChanged: ({bool? required}) {
                      setState(() {
                        _isRequired = required ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 12),
                  MaxOptionsWidget(
                    onChanged: (value) {},
                  ),
                ],
              )
            else
              Row(
                children: [
                  RequiredCheckbox(
                    isRequired: _isRequired,
                    onChanged: ({bool? required}) {
                      setState(() {
                        _isRequired = required ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: MaxOptionsWidget(
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Text(
              AppStrings.numberOfOptionsLabel(_maxOptions),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            CustomInvertedButton(
              onPressed: () {},
              text: '+ ${AppStrings.addOptionButton}',
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 12,
                runSpacing: 12,
                children: [
                  CustomInvertedButton(
                    onPressed: () {},
                    text: AppStrings.cancelButton,
                  ),
                  CustomPrimaryButton(
                    onPressed: () {},
                    text: AppStrings.saveButton,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
