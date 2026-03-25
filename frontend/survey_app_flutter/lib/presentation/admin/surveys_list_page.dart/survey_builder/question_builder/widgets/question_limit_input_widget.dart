import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Types of numeric limits used in question builder sections.
enum QuestionLimitType {
  /// Maximum number of selected options for multi-choice questions.
  maxOptions,

  /// Maximum number of characters for free-text questions.
  maxCharacters,
}

/// Shared input widget for question limit fields.
class QuestionLimitInputWidget extends StatelessWidget {
  /// Constructs a [QuestionLimitInputWidget].
  const QuestionLimitInputWidget({
    required this.type,
    required this.onChanged,
    super.key,
  });

  /// Determines label and placeholder to display.
  final QuestionLimitType type;

  /// Callback fired when the input value changes.
  final void Function(String) onChanged;

  String get _label {
    switch (type) {
      case QuestionLimitType.maxOptions:
        return AppStrings.maxOptionsLabel;
      case QuestionLimitType.maxCharacters:
        return AppStrings.maxCharactersLabel;
    }
  }

  String get _placeholder {
    switch (type) {
      case QuestionLimitType.maxOptions:
        return AppStrings.maxOptionsPlaceholder;
      case QuestionLimitType.maxCharacters:
        return AppStrings.maxCharactersPlaceholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_label *',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextfield(
          hintText: _placeholder,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
