import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_bloc.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_event.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Section widget for displaying survey comments in the results page.
class ResultsCommentsSection extends StatelessWidget {
  /// Constructs a [ResultsCommentsSection].
  const ResultsCommentsSection({
    required this.survey,
    super.key,
  });

  /// Survey for which comments are displayed.
  final SurveyEntity survey;

  List<QuestionEntity> get _textQuestions {
    final seenIds = <String>{};

    return survey.questions.where((question) {
      if (question.type != QuestionType.text) {
        return false;
      }

      final questionId = question.id.trim();
      if (questionId.isEmpty) {
        return false;
      }

      return seenIds.add(questionId);
    }).toList();
  }

  int _totalPages(int count) {
    if (count <= 0) return 1;
    return count;
  }

  List<int> _visiblePages(int currentPage, int totalPages) {
    if (totalPages <= 3) {
      return List<int>.generate(totalPages, (index) => index + 1);
    }

    if (currentPage <= 2) {
      return const [1, 2, 3];
    }

    if (currentPage >= totalPages - 1) {
      return [totalPages - 2, totalPages - 1, totalPages];
    }

    return [currentPage - 1, currentPage, currentPage + 1];
  }

  String _formatCommentDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '';
    }

    final parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate == null) {
      return rawDate;
    }

    const monthLabels = <int, String>{
      1: 'ian',
      2: 'feb',
      3: 'mar',
      4: 'apr',
      5: 'mai',
      6: 'iun',
      7: 'iul',
      8: 'aug',
      9: 'sep',
      10: 'oct',
      11: 'nov',
      12: 'dec',
    };

    final month = monthLabels[parsedDate.month] ?? '';
    return '${parsedDate.day} $month ${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textQuestions = _textQuestions;

    if (textQuestions.isEmpty) {
      return Text(
        AppStrings.resultsCommentsNoTextQuestions,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        final currentPage = state.currentPage;
        final availableQuestionIds = textQuestions
            .map((question) => question.id.trim())
            .toSet();
        final selectedQuestionId =
            availableQuestionIds.contains(
              state.selectedQuestionId?.trim(),
            )
            ? state.selectedQuestionId?.trim()
            : null;
        final comments = state.comments;
        final totalPages = _totalPages(state.commentsTotalPages);
        final safeCurrentPage = currentPage.clamp(1, totalPages);
        final visiblePages = _visiblePages(safeCurrentPage, totalPages);
        final List<AnswerEntity> pageComments = comments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextfield(
                    hintText: AppStrings.resultsCommentsSearchHint,
                    onChanged: (value) {
                      AppBlocs.resultsBloc.add(
                        CommentsSearchTermChangedEvent(value),
                      );
                      AppBlocs.resultsBloc.add(
                        FetchCommentsEvent(
                          survey.id,
                          searchTerm: value,
                          page: 1,
                          questionId: selectedQuestionId,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        isExpanded: true,
                        value: selectedQuestionId,
                        hint: Text(
                          AppStrings.resultsCommentsQuestionDropdownPlaceholder,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              AppStrings
                                  .resultsCommentsQuestionDropdownPlaceholder,
                            ),
                          ),
                          ...textQuestions.map(
                            (question) => DropdownMenuItem<String?>(
                              value: question.id.trim(),
                              child: Text(
                                AppStrings.publicQuestionTitle(
                                  question.order,
                                  question.title,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          final normalizedQuestionId =
                              value == null || value.trim().isEmpty
                              ? null
                              : value.trim();

                          if (normalizedQuestionId !=
                              state.selectedQuestionId) {
                            AppBlocs.resultsBloc.add(
                              CommentsQuestionFilterChangedEvent(
                                normalizedQuestionId,
                              ),
                            );
                          }

                          AppBlocs.resultsBloc.add(
                            FetchCommentsEvent(
                              survey.id,
                              searchTerm: state.searchTerm,
                              page: 1,
                              questionId: normalizedQuestionId,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.resultsCommentsSummary(
                state.commentsTotalCount,
                safeCurrentPage,
                totalPages,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (pageComments.isEmpty)
              Text(
                AppStrings.resultsCommentsNoMatches,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                children: List.generate(pageComments.length, (index) {
                  final answer = pageComments[index];
                  final body = answer.textValue ?? '';
                  final email = (answer.email ?? '').trim();
                  final submittedAt = _formatCommentDate(answer.submittedAt);

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == pageComments.length - 1 ? 0 : 10,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.resultsCommentMeta(
                                email,
                                submittedAt,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  height: 44,
                  child: CustomButton(
                    onPressed: safeCurrentPage > 1
                        ? () {
                            final nextPage = safeCurrentPage - 1;
                            AppBlocs.resultsBloc.add(
                              CommentsPageChangedEvent(nextPage),
                            );
                            AppBlocs.resultsBloc.add(
                              FetchCommentsEvent(
                                survey.id,
                                searchTerm: state.searchTerm,
                                page: nextPage,
                                questionId: selectedQuestionId,
                              ),
                            );
                          }
                        : null,
                    isEnabled: safeCurrentPage > 1,
                    text: '← ${AppStrings.resultsCommentsPrevButton}',
                  ),
                ),
                ...visiblePages.map((page) {
                  final isSelected = page == safeCurrentPage;

                  return SizedBox(
                    height: 44,
                    width: 76,
                    child: CustomButton(
                      onPressed: () {
                        AppBlocs.resultsBloc.add(
                          CommentsPageChangedEvent(page),
                        );
                        AppBlocs.resultsBloc.add(
                          FetchCommentsEvent(
                            survey.id,
                            searchTerm: state.searchTerm,
                            page: page,
                            questionId: selectedQuestionId,
                          ),
                        );
                      },
                      text: '$page',
                      variant: isSelected
                          ? CustomColorVariant.primary
                          : CustomColorVariant.normal,
                    ),
                  );
                }),
                SizedBox(
                  height: 44,
                  child: CustomButton(
                    onPressed: safeCurrentPage < totalPages
                        ? () {
                            final nextPage = safeCurrentPage + 1;
                            AppBlocs.resultsBloc.add(
                              CommentsPageChangedEvent(nextPage),
                            );
                            AppBlocs.resultsBloc.add(
                              FetchCommentsEvent(
                                survey.id,
                                searchTerm: state.searchTerm,
                                page: nextPage,
                                questionId: selectedQuestionId,
                              ),
                            );
                          }
                        : null,
                    isEnabled: safeCurrentPage < totalPages,
                    text: '${AppStrings.resultsCommentsNextButton} →',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
