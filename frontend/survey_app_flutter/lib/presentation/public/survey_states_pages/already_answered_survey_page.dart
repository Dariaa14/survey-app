import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page displayed when a user has already answered a survey.
class AlreadyAnsweredSurveyPage extends StatelessWidget {
  /// Constructs an [AlreadyAnsweredSurveyPage].
  const AlreadyAnsweredSurveyPage({super.key});

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
                AppStrings.alreadyAnsweredSurveyTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.alreadyAnsweredSurveyMessage,
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
