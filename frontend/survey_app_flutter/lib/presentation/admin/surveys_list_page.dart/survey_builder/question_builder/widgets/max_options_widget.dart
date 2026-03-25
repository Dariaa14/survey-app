import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that represents the maximum options for a multi-choice question
/// in the survey builder.
class MaxOptionsWidget extends StatelessWidget {
  /// Constructs a [MaxOptionsWidget].
  const MaxOptionsWidget({required this.onChanged, super.key});

  /// A callback function that is called when the maximum options value changes.
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.maxOptionsLabel} *',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextfield(
          onChanged: onChanged,
        ),
      ],
    );
  }
}
