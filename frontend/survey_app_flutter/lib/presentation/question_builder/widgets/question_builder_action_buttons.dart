import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Shared action buttons for question builder sections.
class QuestionBuilderActionButtons extends StatelessWidget {
  /// Constructs [QuestionBuilderActionButtons].
  const QuestionBuilderActionButtons({
    required this.onSave,
    this.onCancel,
    super.key,
  });

  /// Callback for cancel action.
  final VoidCallback? onCancel;

  /// Callback for save action.
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final cancelAction = onCancel ?? () => Navigator.maybePop(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 12,
        runSpacing: 12,
        children: [
          CustomButton(
            onPressed: cancelAction,
            text: AppStrings.cancelButton,
          ),
          CustomButton(
            onPressed: onSave,
            text: AppStrings.saveButton,
            variant: CustomColorVariant.primary,
          ),
        ],
      ),
    );
  }
}
