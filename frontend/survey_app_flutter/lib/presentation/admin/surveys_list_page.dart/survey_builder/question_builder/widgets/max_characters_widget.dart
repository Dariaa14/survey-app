import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that represents the maximum characters input in the free-text question builder.
class MaxCharactersWidget extends StatelessWidget {
  /// Constructs a [MaxCharactersWidget].
  const MaxCharactersWidget({this.onChanged, super.key});

  /// A callback function that is called when the maximum characters value changes.
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppStrings.maxCharactersLabel} *',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextfield(
          hintText: AppStrings.maxCharactersPlaceholder,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
