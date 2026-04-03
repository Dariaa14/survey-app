import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_bloc.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_event.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// Page for displaying the survey formular to users.
class SurveyFormularPage extends StatefulWidget {
  /// Constructs a [SurveyFormularPage].
  const SurveyFormularPage({
    required this.slug,
    required this.token,
    super.key,
  });

  /// Survey slug from route path.
  final String slug;

  /// Invitation token from route query parameter.
  final String token;

  @override
  State<SurveyFormularPage> createState() => _SurveyFormularPageState();
}

class _SurveyFormularPageState extends State<SurveyFormularPage> {
  @override
  void initState() {
    super.initState();

    AppBlocs.publicBloc.add(
      PublicSurveyRequested(slug: widget.slug, token: widget.token),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PublicBloc, PublicState>(
      bloc: AppBlocs.publicBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Text(
                state.errorMessage!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final survey = state.survey;
        if (survey == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Survey not found.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    survey.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    survey.description ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Column(
                    children: List.generate(
                      survey.questions.length,
                      (index) {
                        final question = survey.questions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (question.options != null &&
                                    question.options!.isNotEmpty)
                                  Column(
                                    children: List.generate(
                                      question.options!.length,
                                      (optionIndex) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<int>(
                                              value: optionIndex,
                                              groupValue: null,
                                              onChanged: (value) {},
                                            ),
                                            Expanded(
                                              child: Text(
                                                question
                                                    .options![optionIndex]
                                                    .label,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    'Mock answer option 1',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    onPressed: () {},
                    text: 'Trimite raspunsurile ->',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
