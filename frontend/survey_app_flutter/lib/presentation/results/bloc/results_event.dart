/// Event for the results screen.
abstract class ResultsEvent {}

/// Event triggered when the selected tab index changes.
class TabChangedEvent extends ResultsEvent {
  /// Constructs a [TabChangedEvent].
  TabChangedEvent(this.index);

  /// Index of the newly selected tab.
  final int index;
}

/// Event triggered when export CSV is requested.
class ExportCsvRequestedEvent extends ResultsEvent {
  /// Constructs an [ExportCsvRequestedEvent].
  ExportCsvRequestedEvent(this.surveyId);

  /// ID of the survey to export.
  final String surveyId;
}

/// Event triggered when the search term in comments changes.
class CommentsSearchTermChangedEvent extends ResultsEvent {
  /// Constructs a [CommentsSearchTermChangedEvent].
  CommentsSearchTermChangedEvent(this.searchTerm);

  /// The new search term.
  final String searchTerm;
}

/// Event triggered when the current page for comments changes.
class CommentsPageChangedEvent extends ResultsEvent {
  /// Constructs a [CommentsPageChangedEvent].
  CommentsPageChangedEvent(this.page);

  /// The new page number (1-indexed).
  final int page;
}

/// Event triggered when the selected question filter changes.
class CommentsQuestionFilterChangedEvent extends ResultsEvent {
  /// Constructs a [CommentsQuestionFilterChangedEvent].
  CommentsQuestionFilterChangedEvent(this.questionId);

  /// The newly selected question ID, or null to clear the filter.
  final String? questionId;
}

/// Event triggered to fetch survey summary data.
class FetchSummaryEvent extends ResultsEvent {
  /// Constructs a [FetchSummaryEvent].
  FetchSummaryEvent(this.surveyId);

  /// ID of the survey to fetch summary for.
  final String surveyId;
}

/// Event triggered to fetch question statistics.
class FetchQuestionStatsEvent extends ResultsEvent {
  /// Constructs a [FetchQuestionStatsEvent].
  FetchQuestionStatsEvent(this.surveyId);

  /// ID of the survey to fetch question stats for.
  final String surveyId;
}

/// Event triggered to fetch survey comments.
class FetchCommentsEvent extends ResultsEvent {
  /// Constructs a [FetchCommentsEvent].
  FetchCommentsEvent(
    this.surveyId, {
    this.searchTerm = '',
    this.page = 1,
    this.questionId,
  });

  /// ID of the survey to fetch comments for.
  final String surveyId;

  /// Optional search term to filter comments.
  final String searchTerm;

  /// Page number for pagination (1-indexed).
  final int page;

  /// Optional question ID filter.
  final String? questionId;
}
