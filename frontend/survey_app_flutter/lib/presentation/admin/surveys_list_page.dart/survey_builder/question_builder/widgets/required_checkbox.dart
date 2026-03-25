import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that represents a required checkbox in the survey builder.
class RequiredCheckbox extends StatelessWidget {
  /// Constructs a [RequiredCheckbox].
  const RequiredCheckbox({
    required this.isRequired,
    required this.onChanged,
    super.key,
  });

  /// Indicates whether the question is required or not.
  final bool isRequired;

  /// A callback function that is called when the checkbox value changes.
  final void Function({bool? required}) onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isRequired,
          onChanged: (value) => onChanged(required: value),
        ),
        Text(
          AppStrings.requiredLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
