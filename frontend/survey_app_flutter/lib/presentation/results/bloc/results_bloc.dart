import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/use_cases/response_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_event.dart';
import 'package:survey_app_flutter/presentation/results/bloc/results_state.dart';
import 'package:survey_app_flutter/utils/file_download_service.dart';

/// Bloc for managing the state of the results screen.
class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  /// Constructor for the [ResultsBloc], initializes with the initial state.
  ResultsBloc(this._responseUseCase, this._userUseCase)
    : super(const ResultsState()) {
    on<TabChangedEvent>(_onTabChanged);
    on<ExportCsvRequestedEvent>(_onExportCsvRequested);
    on<CommentsSearchTermChangedEvent>(_onCommentsSearchTermChanged);
    on<CommentsPageChangedEvent>(_onCommentsPageChanged);
    on<CommentsQuestionFilterChangedEvent>(_onCommentsQuestionFilterChanged);
    on<FetchSummaryEvent>(_onFetchSummary);
    on<FetchQuestionStatsEvent>(_onFetchQuestionStats);
    on<FetchCommentsEvent>(_onFetchComments);
    on<ResultsLiveUpdatesStartedEvent>(_onLiveUpdatesStarted);
    on<ResultsLiveUpdatesStoppedEvent>(_onLiveUpdatesStopped);
    on<ResultsResponsesChangedEvent>(_onResponsesChanged);
  }

  final ResponseUseCase _responseUseCase;
  final UserUseCase _userUseCase;
  StreamSubscription<void>? _liveUpdatesSubscription;
  String? _liveUpdatesSurveyId;

  Future<void> _onTabChanged(
    TabChangedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  Future<void> _onExportCsvRequested(
    ExportCsvRequestedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(state.copyWith(isExporting: true).copyWithNull(nullExportError: true));

    try {
      final token = await _userUseCase.getAuthToken();
      final csvContent = await _responseUseCase.exportSurveyResultsCsv(
        surveyId: event.surveyId,
        token: token,
      );

      // Generate filename with timestamp
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')[0];
      final fileName = 'survey_results_${event.surveyId}_$timestamp.csv';

      // Trigger browser download
      await FileDownloadService.downloadCsv(
        csvContent: csvContent,
        fileName: fileName,
      );

      emit(state.copyWith(isExporting: false));
    } catch (e) {
      emit(
        state.copyWith(
          isExporting: false,
          exportError: 'Failed to export CSV: $e',
        ),
      );
    }
  }

  Future<void> _onCommentsSearchTermChanged(
    CommentsSearchTermChangedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    // Reset to page 1 when search term changes
    emit(state.copyWith(searchTerm: event.searchTerm, currentPage: 1));
  }

  Future<void> _onCommentsPageChanged(
    CommentsPageChangedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(state.copyWith(currentPage: event.page));
  }

  Future<void> _onCommentsQuestionFilterChanged(
    CommentsQuestionFilterChangedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    if (event.questionId == null) {
      return emit(
        state
            .copyWith(currentPage: 1)
            .copyWithNull(nullSelectedQuestionId: true),
      );
    }
    emit(state.copyWith(selectedQuestionId: event.questionId, currentPage: 1));
  }

  Future<void> _onFetchSummary(
    FetchSummaryEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(
      state.copyWith(summaryLoading: true).copyWithNull(nullSummaryError: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      final summary = await _responseUseCase.getSurveyResultsSummary(
        surveyId: event.surveyId,
        token: token,
      );

      emit(state.copyWith(summary: summary, summaryLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          summaryLoading: false,
          summaryError: 'Failed to fetch summary: $e',
        ),
      );
    }
  }

  Future<void> _onFetchQuestionStats(
    FetchQuestionStatsEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(
      state
          .copyWith(questionStatsLoading: true)
          .copyWithNull(nullQuestionStatsError: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      final stats = await _responseUseCase.getSurveyQuestionStats(
        surveyId: event.surveyId,
        token: token,
      );

      emit(state.copyWith(questionStats: stats, questionStatsLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          questionStatsLoading: false,
          questionStatsError: 'Failed to fetch question stats: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onFetchComments(
    FetchCommentsEvent event,
    Emitter<ResultsState> emit,
  ) async {
    emit(
      state
          .copyWith(commentsLoading: true)
          .copyWithNull(nullCommentsError: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      final comments = await _responseUseCase.getSurveyComments(
        surveyId: event.surveyId,
        query: event.searchTerm,
        page: event.page,
        questionId: event.questionId,
        token: token,
      );

      emit(state.copyWith(comments: comments, commentsLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          commentsLoading: false,
          commentsError: 'Failed to fetch comments: $e',
        ),
      );
    }
  }

  Future<void> _onLiveUpdatesStarted(
    ResultsLiveUpdatesStartedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    if (_liveUpdatesSurveyId == event.surveyId &&
        _liveUpdatesSubscription != null) {
      return;
    }

    await _liveUpdatesSubscription?.cancel();
    if (_liveUpdatesSurveyId != null) {
      await _responseUseCase.stopWatchingSurveyResults(
        surveyId: _liveUpdatesSurveyId,
      );
    }

    _liveUpdatesSurveyId = event.surveyId;
    _liveUpdatesSubscription = _responseUseCase
        .watchSurveyResults(surveyId: event.surveyId)
        .listen((_) {
          add(ResultsResponsesChangedEvent(event.surveyId));
        });
  }

  Future<void> _onLiveUpdatesStopped(
    ResultsLiveUpdatesStoppedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    await _liveUpdatesSubscription?.cancel();
    _liveUpdatesSubscription = null;
    final surveyId = _liveUpdatesSurveyId;
    _liveUpdatesSurveyId = null;
    if (surveyId != null) {
      await _responseUseCase.stopWatchingSurveyResults(surveyId: surveyId);
    }
  }

  Future<void> _onResponsesChanged(
    ResultsResponsesChangedEvent event,
    Emitter<ResultsState> emit,
  ) async {
    add(FetchSummaryEvent(event.surveyId));
    add(FetchQuestionStatsEvent(event.surveyId));
    add(
      FetchCommentsEvent(
        event.surveyId,
        searchTerm: state.searchTerm,
        page: state.currentPage,
        questionId: state.selectedQuestionId,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _liveUpdatesSubscription?.cancel();
    final surveyId = _liveUpdatesSurveyId;
    _liveUpdatesSubscription = null;
    _liveUpdatesSurveyId = null;
    if (surveyId != null) {
      await _responseUseCase.stopWatchingSurveyResults(surveyId: surveyId);
    }
    return super.close();
  }
}
