import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_data.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/sections/widgets/survey_preview_widgets/survey_preview_status.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/widgets/my_surveys_filter.dart';

/// A section that displays the list of surveys created by the admin.
class MySurveysListSection extends StatelessWidget {
  /// Constructs a [MySurveysListSection].
  const MySurveysListSection({super.key});

  List<SurveyPreviewData> _mockSurveys() {
    return const [
      SurveyPreviewData(
        id: 1,
        title: 'Feedback produs nou',
        description:
            'Colectam pareri despre noul nostru produs lansat luna aceasta.',
        slug: 'feedback-produs-nou',
        questionCount: 7,
        createdAt: '12 martie 2026',
        status: SurveyPreviewStatus.published,
        invitationsCount: 240,
        submitRate: 63,
      ),
      SurveyPreviewData(
        id: 2,
        title: 'Satisfactie clienti B2B',
        description:
            'Evaluam nivelul de satisfactie al clientilor business pentru a imbunatati serviciile oferite.',
        slug: 'satisfactie-clienti-b2b',
        questionCount: 5,
        createdAt: '05 martie 2026',
        status: SurveyPreviewStatus.draft,
      ),
      SurveyPreviewData(
        id: 3,
        title: 'Retrospectiva campanie iarna',
        description:
            'Analizam performanta campaniei de iarna pentru a identifica punctele de îmbunătățire.',
        slug: 'retrospectiva-campanie-iarna',
        questionCount: 9,
        createdAt: '14 februarie 2026',
        status: SurveyPreviewStatus.closed,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final surveys = _mockSurveys();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MySurveysFilter(),
        const SizedBox(height: 24),
        ...surveys.map(
          (survey) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SurveyPreview(survey: survey),
          ),
        ),
      ],
    );
  }
}
