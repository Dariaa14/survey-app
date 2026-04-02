import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview_widgets/survey_status_badge.dart';
import 'package:survey_app_flutter/presentation/invitations/widgets/send_invitations_section.dart';
import 'package:survey_app_flutter/presentation/invitations/widgets/sent_invitations_section.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page showing the list of invitations for a survey.
class SurveyInvitationsPage extends StatelessWidget {
  /// Constructs a [SurveyInvitationsPage].
  const SurveyInvitationsPage({required this.survey, super.key});

  /// Survey for which invitations are displayed.
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.surveyInvitationsTitle(survey.title),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SurveyStatusBadge(survey: survey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.surveyInvitationsSlug(survey.slug),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SendInvitationsSection(),
                const SizedBox(height: 24),
                const SentInvitationsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
