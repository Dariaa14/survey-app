import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_bloc.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_event.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_state.dart';
import 'package:survey_app_flutter/presentation/results/sections/results_comments_section.dart';
import 'package:survey_app_flutter/presentation/results/sections/results_questions_section.dart';
import 'package:survey_app_flutter/presentation/results/widgets/results_horizontal_info.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page that displays the results of a survey.
class ResultsPage extends StatefulWidget {
  /// Constructs a [ResultsPage].
  const ResultsPage({
    required this.survey,
    super.key,
  });

  /// Survey whose results are displayed.
  final SurveyEntity survey;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  void initState() {
    super.initState();
    AppBlocs.resultsBloc.add(ResultsLiveUpdatesStartedEvent(widget.survey.id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    AppBlocs.resultsBloc.add(ResultsLiveUpdatesStoppedEvent());
    super.dispose();
  }

  void _initializeData() {
    AppBlocs.resultsBloc.add(FetchSummaryEvent(widget.survey.id));
    AppBlocs.resultsBloc.add(FetchQuestionStatsEvent(widget.survey.id));
    AppBlocs.resultsBloc.add(FetchCommentsEvent(widget.survey.id));
  }

  double _measureTabWidth(BuildContext context, String label) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
    );

    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.width + 8;
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent(BuildContext context, int tabIndex) {
    if (tabIndex == 0) {
      return ResultsQuestionsSection(survey: widget.survey);
    }

    return ResultsCommentsSection(survey: widget.survey);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProviders(
      child: BlocBuilder<ResultsBloc, ResultsState>(
        builder: (context, state) {
          final selectedTabIndex = state.selectedTabIndex;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.resultsPageTitle(
                                  widget.survey.title,
                                ),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppStrings.resultsPageSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 170,
                          child: CustomButton(
                            onPressed: state.isExporting
                                ? null
                                : () {
                                    AppBlocs.resultsBloc.add(
                                      ExportCsvRequestedEvent(
                                        widget.survey.id,
                                      ),
                                    );
                                  },
                            text: state.isExporting
                                ? AppStrings.resultsExporting
                                : AppStrings.resultsExportCsvButton,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.resultsFunnelTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ResultsHorizontalInfo(summary: state.summary),

                    const SizedBox(height: 20),
                    Builder(
                      builder: (context) {
                        const gap = 20.0;
                        final intrebariWidth = _measureTabWidth(
                          context,
                          AppStrings.resultsQuestionsTab,
                        );
                        final comentariiWidth = _measureTabWidth(
                          context,
                          AppStrings.resultsCommentsTab,
                        );

                        final indicatorLeft = selectedTabIndex == 0
                            ? 0.0
                            : intrebariWidth + gap;
                        final indicatorWidth = selectedTabIndex == 0
                            ? intrebariWidth
                            : comentariiWidth;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: intrebariWidth,
                                  child: _buildTab(
                                    context,
                                    label: AppStrings.resultsQuestionsTab,
                                    index: 0,
                                    isSelected: selectedTabIndex == 0,
                                    onTap: () {
                                      AppBlocs.resultsBloc.add(
                                        TabChangedEvent(0),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: gap),
                                SizedBox(
                                  width: comentariiWidth,
                                  child: _buildTab(
                                    context,
                                    label: AppStrings.resultsCommentsTab,
                                    index: 1,
                                    isSelected: selectedTabIndex == 1,
                                    onTap: () {
                                      AppBlocs.resultsBloc.add(
                                        TabChangedEvent(1),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    left: indicatorLeft,
                                    width: indicatorWidth,
                                    child: Container(
                                      height: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSelectedTabContent(context, selectedTabIndex),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
