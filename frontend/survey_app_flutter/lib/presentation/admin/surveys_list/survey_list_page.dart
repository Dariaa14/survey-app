import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/survey_preview.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list/widgets/surveys_filter.dart';

/// A section that displays the list of surveys created by the admin.
class SurveyListPage extends StatelessWidget {
  /// Constructs a [SurveyListPage].
  const SurveyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (previous, current) => previous.surveys != current.surveys,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SurveysFilter(),
            const SizedBox(height: 24),
            ...state.surveys.map(
              (survey) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SurveyPreview(survey: survey),
              ),
            ),
          ],
        );
      },
    );
  }
}
