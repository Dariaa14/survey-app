import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/widgets/max_characters_widget.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/widgets/required_checkbox.dart';
import 'package:survey_app_flutter/shared/custom_inverted_button.dart';
import 'package:survey_app_flutter/shared/custom_primary_button.dart';
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
                  MaxCharactersWidget(
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
                    child: MaxCharactersWidget(
                      onChanged: (value) {},
                    ),
                  ),
                ],
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
