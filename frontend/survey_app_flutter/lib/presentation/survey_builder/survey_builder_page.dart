import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_state.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/survey_builder_details_section.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/survey_builder_questions_section.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// A page for building and editing surveys in the admin section.
class SurveyBuilderPage extends StatefulWidget {
  /// Constructs a [SurveyBuilderPage].
  const SurveyBuilderPage({this.survey, super.key});

  /// Optional full survey payload passed from navigation.
  final SurveyEntity? survey;

  @override
  State<SurveyBuilderPage> createState() => _SurveyBuilderPageState();
}

class _SurveyBuilderPageState extends State<SurveyBuilderPage> {
  late TextEditingController _surveyTitleController;
  late TextEditingController _surveyDescriptionController;
  late TextEditingController _surveySlugController;

  @override
  void initState() {
    super.initState();
    _surveyTitleController = TextEditingController(
      text: widget.survey?.title ?? '',
    );
    _surveyDescriptionController = TextEditingController(
      text: widget.survey?.description ?? '',
    );
    _surveySlugController = TextEditingController(
      text: widget.survey?.slug ?? '',
    );
  }

  @override
  void dispose() {
    _surveyTitleController.dispose();
    _surveyDescriptionController.dispose();
    _surveySlugController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: Scaffold(
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
                            BlocBuilder<SurveyBuilderBloc, SurveyBuilderState>(
                              bloc: AppBlocs.surveyBuilderBloc,
                              buildWhen: (previous, current) =>
                                  previous.questions != current.questions,
                              builder: (context, state) {
                                return SurveyBuilderQuestionsSection(
                                  questions: state.questions,
                                  expand: false,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            SurveyBuilderDetailsSection(
                              surveyTitleController: _surveyTitleController,
                              surveyDescriptionController:
                                  _surveyDescriptionController,
                              surveySlugController: _surveySlugController,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 360,
                              child: SurveyBuilderDetailsSection(
                                surveyTitleController: _surveyTitleController,
                                surveyDescriptionController:
                                    _surveyDescriptionController,
                                surveySlugController: _surveySlugController,
                              ),
                            ),
                            const SizedBox(width: 24),
                            BlocBuilder<SurveyBuilderBloc, SurveyBuilderState>(
                              bloc: AppBlocs.surveyBuilderBloc,
                              buildWhen: (previous, current) =>
                                  previous.questions != current.questions,
                              builder: (context, state) {
                                return SurveyBuilderQuestionsSection(
                                  questions: state.questions,
                                );
                              },
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
