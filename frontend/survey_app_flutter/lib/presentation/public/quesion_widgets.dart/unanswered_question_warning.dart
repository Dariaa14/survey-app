import 'package:flutter/material.dart';

/// Widget that displays a warning when a user tries to
/// submit a survey with unanswered questions.
class UnansweredQuestionWarning extends StatelessWidget {
  /// Constructs an [UnansweredQuestionWarning].
  const UnansweredQuestionWarning({
    required this.message,
    super.key,
  });

  /// Warning text to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        border: Border.all(color: colorScheme.error),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
