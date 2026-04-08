import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/answer_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_stat_entity.dart';
import 'package:survey_app_flutter/domain/entities/results_summary_entity.dart';

/// State for the results screen.
class ResultsState extends Equatable {
  /// Constructs a [ResultsState].
  const ResultsState({
    this.selectedTabIndex = 0,
    this.isExporting = false,
    this.exportError,
    this.searchTerm = '',
    this.currentPage = 1,
    this.selectedQuestionId,
    this.summary,
    this.summaryLoading = false,
    this.summaryError,
    this.questionStats = const [],
    this.questionStatsLoading = false,
    this.questionStatsError,
    this.comments = const [],
    this.commentsTotalPages = 1,
    this.commentsTotalCount = 0,
    this.commentsLoading = false,
    this.commentsError,
  });

  /// Currently selected tab index (0 = Questions, 1 = Comments).
  final int selectedTabIndex;

  /// Whether CSV export is currently in progress.
  final bool isExporting;

  /// Error message if CSV export failed.
  final String? exportError;

  /// Current search term for comments filtering.
  final String searchTerm;

  /// Current page number for comments pagination (1-indexed).
  final int currentPage;

  /// Currently selected question ID for comments filtering. Null = no filter.
  final String? selectedQuestionId;

  /// Summary data containing invitation/response counts.
  final ResultsSummaryEntity? summary;

  /// Whether summary data is being fetched.
  final bool summaryLoading;

  /// Error message if summary fetch failed.
  final String? summaryError;

  /// List of question statistics for display.
  final List<QuestionStatEntity> questionStats;

  /// Whether question stats are being fetched.
  final bool questionStatsLoading;

  /// Error message if question stats fetch failed.
  final String? questionStatsError;

  /// List of comments with optional filtering and pagination.
  final List<AnswerEntity> comments;

  /// Total number of pages for comments query.
  final int commentsTotalPages;

  /// Total number of matching comments for current query.
  final int commentsTotalCount;

  /// Whether comments are being fetched.
  final bool commentsLoading;

  /// Error message if comments fetch failed.
  final String? commentsError;

  /// Creates a copy of this state with modified fields.
  ResultsState copyWith({
    int? selectedTabIndex,
    bool? isExporting,
    String? exportError,
    String? searchTerm,
    int? currentPage,
    String? selectedQuestionId,
    ResultsSummaryEntity? summary,
    bool? summaryLoading,
    String? summaryError,
    List<QuestionStatEntity>? questionStats,
    bool? questionStatsLoading,
    String? questionStatsError,
    List<AnswerEntity>? comments,
    int? commentsTotalPages,
    int? commentsTotalCount,
    bool? commentsLoading,
    String? commentsError,
  }) {
    return ResultsState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isExporting: isExporting ?? this.isExporting,
      exportError: exportError ?? this.exportError,
      searchTerm: searchTerm ?? this.searchTerm,
      currentPage: currentPage ?? this.currentPage,
      selectedQuestionId: selectedQuestionId ?? this.selectedQuestionId,
      summary: summary ?? this.summary,
      summaryLoading: summaryLoading ?? this.summaryLoading,
      summaryError: summaryError ?? this.summaryError,
      questionStats: questionStats ?? this.questionStats,
      questionStatsLoading: questionStatsLoading ?? this.questionStatsLoading,
      questionStatsError: questionStatsError ?? this.questionStatsError,
      comments: comments ?? this.comments,
      commentsTotalPages: commentsTotalPages ?? this.commentsTotalPages,
      commentsTotalCount: commentsTotalCount ?? this.commentsTotalCount,
      commentsLoading: commentsLoading ?? this.commentsLoading,
      commentsError: commentsError ?? this.commentsError,
    );
  }

  /// Creates a copy of this state with specified error fields set to null.
  ResultsState copyWithNull({
    bool nullExportError = false,
    bool nullSummaryError = false,
    bool nullQuestionStatsError = false,
    bool nullCommentsError = false,
    bool nullSelectedQuestionId = false,
  }) {
    return ResultsState(
      selectedTabIndex: selectedTabIndex,
      isExporting: isExporting,
      exportError: nullExportError ? null : exportError,
      searchTerm: searchTerm,
      currentPage: currentPage,
      selectedQuestionId: nullSelectedQuestionId ? null : selectedQuestionId,
      summary: summary,
      summaryLoading: summaryLoading,
      summaryError: nullSummaryError ? null : summaryError,
      questionStats: questionStats,
      questionStatsLoading: questionStatsLoading,
      questionStatsError: nullQuestionStatsError ? null : questionStatsError,
      comments: comments,
      commentsTotalPages: commentsTotalPages,
      commentsTotalCount: commentsTotalCount,
      commentsLoading: commentsLoading,
      commentsError: nullCommentsError ? null : commentsError,
    );
  }

  @override
  List<Object?> get props => [
    selectedTabIndex,
    isExporting,
    exportError,
    searchTerm,
    currentPage,
    selectedQuestionId,
    summary,
    summaryLoading,
    summaryError,
    questionStats,
    questionStatsLoading,
    questionStatsError,
    comments,
    commentsTotalPages,
    commentsTotalCount,
    commentsLoading,
    commentsError,
  ];
}
