import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_event.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_state.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/survey_builder_details_section.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/survey_builder_questions_section.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

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

    if (widget.survey != null) {
      AppBlocs.surveyBuilderBloc.add(LoadSurveyForEditing(widget.survey!));
    } else {
      AppBlocs.surveyBuilderBloc.add(ResetSurveyBuilder());
    }

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
    AppBlocs.surveyBuilderBloc.add(ResetSurveyBuilder());
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
          child: BlocBuilder<SurveyBuilderBloc, SurveyBuilderState>(
            bloc: AppBlocs.surveyBuilderBloc,
            buildWhen: (previous, current) =>
                previous.survey?.status != current.survey?.status ||
                previous.questions != current.questions,
            builder: (context, state) {
              final isReadOnly =
                  state.survey != null &&
                  state.survey!.status != SurveyStatus.draft;

              return LayoutBuilder(
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
                                BlocBuilder<
                                  SurveyBuilderBloc,
                                  SurveyBuilderState
                                >(
                                  bloc: AppBlocs.surveyBuilderBloc,
                                  buildWhen: (previous, current) =>
                                      previous.questions != current.questions,
                                  builder: (context, state) {
                                    return SurveyBuilderQuestionsSection(
                                      questions: state.questions,
                                      expand: false,
                                      isReadOnly: isReadOnly,
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
                                  isReadOnly: isReadOnly,
                                ),
                                if (state.survey != null &&
                                    state.survey!.status ==
                                        SurveyStatus.published) ...[
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      onPressed: () {
                                        context.push(
                                          AppRoutes.adminSurveyInvitationsPath(
                                            state.survey!.id,
                                          ),
                                          extra: state.survey,
                                        );
                                      },
                                      text: AppStrings.manageInvitationsButton,
                                      variant: CustomColorVariant.primary,
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 360,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SurveyBuilderDetailsSection(
                                        surveyTitleController:
                                            _surveyTitleController,
                                        surveyDescriptionController:
                                            _surveyDescriptionController,
                                        surveySlugController:
                                            _surveySlugController,
                                        isReadOnly: isReadOnly,
                                      ),
                                      if (state.survey != null &&
                                          state.survey!.status ==
                                              SurveyStatus.published) ...[
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          child: CustomButton(
                                            onPressed: () {
                                              context.push(
                                                AppRoutes.adminSurveyInvitationsPath(
                                                  state.survey!.id,
                                                ),
                                                extra: state.survey,
                                              );
                                            },
                                            text: AppStrings
                                                .manageInvitationsButton,
                                            variant: CustomColorVariant.primary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                BlocBuilder<
                                  SurveyBuilderBloc,
                                  SurveyBuilderState
                                >(
                                  bloc: AppBlocs.surveyBuilderBloc,
                                  buildWhen: (previous, current) =>
                                      previous.questions != current.questions,
                                  builder: (context, state) {
                                    return SurveyBuilderQuestionsSection(
                                      questions: state.questions,
                                      isReadOnly: isReadOnly,
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
