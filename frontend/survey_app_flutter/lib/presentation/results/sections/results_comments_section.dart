import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Section widget for displaying survey comments in the results page.
class ResultsCommentsSection extends StatefulWidget {
  /// Constructs a [ResultsCommentsSection].
  const ResultsCommentsSection({
    required this.survey,
    super.key,
  });

  /// Survey for which comments are displayed.
  final SurveyEntity survey;

  @override
  State<ResultsCommentsSection> createState() => _ResultsCommentsSectionState();
}

class _ResultsCommentsSectionState extends State<ResultsCommentsSection> {
  final TextEditingController _searchController = TextEditingController();

  static const int _itemsPerPage = 10;
  int _currentPage = 1;
  String? _selectedQuestionId;
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QuestionEntity> get _textQuestions {
    return widget.survey.questions
        .where((question) => question.type == QuestionType.text)
        .toList();
  }

  List<_MockComment> _buildMockComments() {
    final textQuestions = _textQuestions;
    if (textQuestions.isEmpty) {
      return const [];
    }

    final firstTextQuestion = textQuestions.first.id;

    return List.generate(17, (index) {
      return _MockComment(
        questionId: firstTextQuestion,
        body:
            'Răspuns text mock #${index + 1}. Feedback-ul utilizatorului despre experiența cu produsul.',
        email: 'ion.popescu${index + 1}@example.com',
        dateLabel: '14 ian 2025',
      );
    });
  }

  List<_MockComment> _filteredComments(List<_MockComment> allComments) {
    return allComments.where((comment) {
      final matchesQuestion =
          _selectedQuestionId == null ||
          comment.questionId == _selectedQuestionId;
      final query = _searchTerm.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          comment.body.toLowerCase().contains(query) ||
          comment.email.toLowerCase().contains(query);

      return matchesQuestion && matchesSearch;
    }).toList();
  }

  int _totalPages(int count) {
    if (count <= 0) return 1;
    return ((count - 1) ~/ _itemsPerPage) + 1;
  }

  List<_MockComment> _pageItems(List<_MockComment> comments) {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, comments.length);
    if (start >= comments.length) {
      return const [];
    }

    return comments.sublist(start, end);
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

    final allComments = _buildMockComments();
    final filteredComments = _filteredComments(allComments);
    final totalPages = _totalPages(filteredComments.length);
    final safeCurrentPage = _currentPage.clamp(1, totalPages);
    final visiblePages = _visiblePages(safeCurrentPage, totalPages);
    final pageComments = _pageItems(filteredComments);

    if (safeCurrentPage != _currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _currentPage = safeCurrentPage;
        });
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                controller: _searchController,
                hintText: AppStrings.resultsCommentsSearchHint,
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                    _currentPage = 1;
                  });
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
                    value: _selectedQuestionId,
                    hint: Text(
                      AppStrings.resultsCommentsQuestionDropdownPlaceholder,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        child: Text(
                          AppStrings.resultsCommentsQuestionDropdownPlaceholder,
                        ),
                      ),
                      ...textQuestions.map(
                        (question) => DropdownMenuItem<String?>(
                          value: question.id,
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
                      setState(() {
                        _selectedQuestionId = value;
                        _currentPage = 1;
                      });
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
            filteredComments.length,
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
              final comment = pageComments[index];

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
                        comment.body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.resultsCommentMeta(
                          comment.email,
                          comment.dateLabel,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
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
                        setState(() {
                          _currentPage = safeCurrentPage - 1;
                        });
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
                width: 56,
                child: CustomButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = page;
                    });
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
                        setState(() {
                          _currentPage = safeCurrentPage + 1;
                        });
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
  }
}

class _MockComment {
  const _MockComment({
    required this.questionId,
    required this.body,
    required this.email,
    required this.dateLabel,
  });

  final String questionId;
  final String body;
  final String email;
  final String dateLabel;
}
