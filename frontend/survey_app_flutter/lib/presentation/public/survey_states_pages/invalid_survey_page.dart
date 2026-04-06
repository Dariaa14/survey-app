import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page displayed when a survey is invalid.
class InvalidSurveyPage extends StatelessWidget {
  /// Constructs an [InvalidSurveyPage].
  const InvalidSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.invalidSurveyTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.invalidSurveyMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
