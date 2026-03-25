import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/question_limit_input_widget.dart';
import 'package:survey_app_flutter/presentation/question_builder/widgets/required_checkbox.dart';

/// Shared section combining required checkbox and limit input.
class RequiredLimitSection extends StatelessWidget {
  /// Constructs a [RequiredLimitSection].
  const RequiredLimitSection({
    required this.isRequired,
    required this.onRequiredChanged,
    required this.limitType,
    required this.onLimitChanged,
    super.key,
  });

  /// Whether the question is required.
  final bool isRequired;

  /// Called when required checkbox changes.
  final void Function({bool? required}) onRequiredChanged;

  /// The limit field type to render.
  final QuestionLimitType limitType;

  /// Called when limit input changes.
  final void Function(String) onLimitChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 560;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequiredCheckbox(
                isRequired: isRequired,
                onChanged: onRequiredChanged,
              ),
              const SizedBox(height: 12),
              QuestionLimitInputWidget(
                type: limitType,
                onChanged: onLimitChanged,
              ),
            ],
          );
        }

        return Row(
          children: [
            RequiredCheckbox(
              isRequired: isRequired,
              onChanged: onRequiredChanged,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: QuestionLimitInputWidget(
                type: limitType,
                onChanged: onLimitChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}
