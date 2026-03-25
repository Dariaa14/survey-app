import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/widgets/survey_builder_details_section.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/survey_builder/widgets/survey_builder_questions_section.dart';

/// A page for building and editing surveys in the admin section.
class SurveyBuilderPage extends StatelessWidget {
  /// Constructs a [SurveyBuilderPage].
  const SurveyBuilderPage({this.surveyId, super.key});

  /// The id of the survey being edited. Null when creating a new survey.
  final String? surveyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 860;
            final pagePadding = isMobile ? 16.0 : 24.0;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(pagePadding),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SurveyBuilderQuestionsSection(
                            expand: false,
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          const SurveyBuilderDetailsSection(),
                        ],
                      )
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 360,
                            child: SurveyBuilderDetailsSection(),
                          ),
                          SizedBox(width: 24),
                          SurveyBuilderQuestionsSection(),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
