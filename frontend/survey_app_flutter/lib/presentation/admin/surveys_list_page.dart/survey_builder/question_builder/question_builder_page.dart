import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/free_text_question_section.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/question_builder/multi_choice_question_section.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A page for building and editing surveys in the admin section.
class QuestionBuilderPage extends StatefulWidget {
  /// Constructs a [QuestionBuilderPage].
  const QuestionBuilderPage({
    this.initialIsMultiChoiceSelected = true,
    super.key,
  });

  /// Initial tab selection when opening the modal.
  final bool initialIsMultiChoiceSelected;

  @override
  State<QuestionBuilderPage> createState() => _QuestionBuilderPageState();
}

class _QuestionBuilderPageState extends State<QuestionBuilderPage> {
  late bool _isMultiChoiceSelected;

  @override
  void initState() {
    super.initState();
    _isMultiChoiceSelected = widget.initialIsMultiChoiceSelected;
  }

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                  if (_isMultiChoiceSelected)
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          _isMultiChoiceSelected = true;
                        });
                      },
                      text: AppStrings.multiChoiceTab,
                      variant: CustomButtonVariant.primary,
                    )
                  else
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          _isMultiChoiceSelected = true;
                        });
                      },
                      text: AppStrings.multiChoiceTab,
                    ),
                  if (!_isMultiChoiceSelected)
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          _isMultiChoiceSelected = false;
                        });
                      },
                      text: AppStrings.freeTextTab,
                      variant: CustomButtonVariant.primary,
                    )
                  else
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          _isMultiChoiceSelected = false;
                        });
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
                    child: _isMultiChoiceSelected
                        ? const MultiChoiceQuestionSection()
                        : const FreeTextQuestionSection(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
