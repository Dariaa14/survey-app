import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/use_cases/email_list_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/response_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';

/// Bloc for managing admin-related state and events.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final EmailListUseCase _emailListUseCase;
  final ResponseUseCase _responseUseCase;
  final SurveyUseCase _surveyUseCase;
  final UserUseCase _userUseCase;
  final Map<String, StreamSubscription<void>> _liveSurveySubscriptions = {};
  Timer? _liveRefreshDebounce;
  bool _isLiveUpdatesEnabled = false;

  /// Constructs an [AdminBloc] with the initial state of [AdminState].
  AdminBloc({
    required EmailListUseCase emailListUseCase,
    required ResponseUseCase responseUseCase,
    required SurveyUseCase surveyUseCase,
    required UserUseCase userUseCase,
  }) : _emailListUseCase = emailListUseCase,
       _responseUseCase = responseUseCase,
       _surveyUseCase = surveyUseCase,
       _userUseCase = userUseCase,
       super(const AdminState()) {
    on<AdminAccountRequested>(_onAccountRequested);
    on<AdminSurveysRequested>(_onSurveysRequested);
    on<AdminSurveysRefreshed>(_onSurveysRefreshed);
    on<AdminEmailListsRequested>(_onEmailListsRequested);
    on<AdminEmailListsRefreshed>(_onEmailListsRefreshed);
    on<AdminEmailListCreateRequested>(_onEmailListCreateRequested);
    on<AdminEmailListUpdateRequested>(_onEmailListUpdateRequested);
    on<AdminEmailListDeleteRequested>(_onEmailListDeleteRequested);
    on<AdminErrorCleared>(_onErrorCleared);
    on<AdminMainTabChanged>(_onMainTabChanged);
    on<AdminSurveyFilterChanged>(_onSurveyFilterChanged);
    on<AdminSurveyPublishRequested>(_onSurveyPublishRequested);
    on<AdminSurveyCloseRequested>(_onSurveyCloseRequested);
    on<AdminLiveUpdatesStarted>(_onLiveUpdatesStarted);
    on<AdminLiveUpdatesStopped>(_onLiveUpdatesStopped);
  }

  void _onMainTabChanged(
    AdminMainTabChanged event,
    Emitter<AdminState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));

    if (event.tab == AdminMainTab.contacts && state.emailLists.isEmpty) {
      add(const AdminEmailListsRequested());
    }
  }

  Future<void> _onAccountRequested(
    AdminAccountRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final adminUser = await _userUseCase.getCurrentUser();

      emit(
        state
            .copyWith(status: AdminStatus.success, adminUser: adminUser)
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSurveysRequested(
    AdminSurveysRequested event,
    Emitter<AdminState> emit,
  ) async {
    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final surveys = await _surveyUseCase.getSurveysByUser(
        adminUser.id,
        token,
      );

      final shouldUseServerFiltering =
          surveys.length >= AdminState.clientSideFilterThreshold;

      emit(
        state
            .copyWith(
              status: AdminStatus.success,
              surveys: surveys,
              usesServerFiltering: shouldUseServerFiltering,
            )
            .copyWithNull(nullErrorMessage: true),
      );

      await _syncLiveSurveySubscriptions(surveys);
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSurveysRefreshed(
    AdminSurveysRefreshed event,
    Emitter<AdminState> emit,
  ) async {
    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final status = state.usesServerFiltering
          ? _filterToStatusQuery(state.selectedFilter)
          : null;
      final surveys = await _surveyUseCase.getSurveysByUser(
        adminUser.id,
        token,
        status: status,
      );

      final shouldUseServerFiltering =
          state.usesServerFiltering ||
          (status == null &&
              surveys.length >= AdminState.clientSideFilterThreshold);

      emit(
        state
            .copyWith(
              status: AdminStatus.success,
              surveys: surveys,
              usesServerFiltering: shouldUseServerFiltering,
            )
            .copyWithNull(nullErrorMessage: true),
      );

      await _syncLiveSurveySubscriptions(surveys);
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEmailListsRequested(
    AdminEmailListsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final emailLists = await _emailListUseCase.getEmailListsByUser(
        ownerId: adminUser.id,
        token: token,
      );

      emit(
        state
            .copyWith(status: AdminStatus.success, emailLists: emailLists)
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEmailListsRefreshed(
    AdminEmailListsRefreshed event,
    Emitter<AdminState> emit,
  ) async {
    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final emailLists = await _emailListUseCase.getEmailListsByUser(
        ownerId: adminUser.id,
        token: token,
      );

      emit(
        state
            .copyWith(status: AdminStatus.success, emailLists: emailLists)
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEmailListCreateRequested(
    AdminEmailListCreateRequested event,
    Emitter<AdminState> emit,
  ) async {
    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      await _emailListUseCase.createEmailList(
        token: token,
        ownerId: adminUser.id,
        name: event.name,
      );

      add(const AdminEmailListsRefreshed());
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEmailListUpdateRequested(
    AdminEmailListUpdateRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      await _emailListUseCase.updateEmailList(
        token: token,
        listId: event.listId,
        name: event.name,
      );

      add(const AdminEmailListsRefreshed());
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEmailListDeleteRequested(
    AdminEmailListDeleteRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      await _emailListUseCase.deleteEmailList(
        token: token,
        listId: event.listId,
      );

      add(const AdminEmailListsRefreshed());
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onErrorCleared(AdminErrorCleared event, Emitter<AdminState> emit) {
    emit(state.copyWithNull(nullErrorMessage: true));
  }

  Future<void> _onSurveyFilterChanged(
    AdminSurveyFilterChanged event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(selectedFilter: event.filter));

    if (!state.usesServerFiltering) {
      return;
    }

    final adminUser = state.adminUser;
    if (adminUser == null) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: 'Admin user not found',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final surveys = await _surveyUseCase.getSurveysByUser(
        adminUser.id,
        token,
        status: _filterToStatusQuery(event.filter),
      );

      emit(
        state
            .copyWith(status: AdminStatus.success, surveys: surveys)
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String? _filterToStatusQuery(AdminSurveyFilter filter) {
    switch (filter) {
      case AdminSurveyFilter.all:
        return null;
      case AdminSurveyFilter.draft:
        return 'draft';
      case AdminSurveyFilter.published:
        return 'published';
      case AdminSurveyFilter.closed:
        return 'closed';
    }
  }

  Future<void> _onSurveyPublishRequested(
    AdminSurveyPublishRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      await _surveyUseCase.publishSurvey(
        token: token,
        surveyId: event.surveyId,
      );

      add(const AdminSurveysRefreshed());
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSurveyCloseRequested(
    AdminSurveyCloseRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AdminStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      await _surveyUseCase.closeSurvey(
        token: token,
        surveyId: event.surveyId,
      );

      add(const AdminSurveysRefreshed());
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLiveUpdatesStarted(
    AdminLiveUpdatesStarted event,
    Emitter<AdminState> emit,
  ) async {
    _isLiveUpdatesEnabled = true;
    await _syncLiveSurveySubscriptions(state.surveys);
  }

  Future<void> _onLiveUpdatesStopped(
    AdminLiveUpdatesStopped event,
    Emitter<AdminState> emit,
  ) async {
    _isLiveUpdatesEnabled = false;
    await _clearLiveSurveySubscriptions();
  }

  Future<void> _syncLiveSurveySubscriptions(List<SurveyEntity> surveys) async {
    final surveyIds = surveys.map((survey) => survey.id).toSet();

    final removedIds = _liveSurveySubscriptions.keys
        .where((id) => !surveyIds.contains(id))
        .toList();

    for (final id in removedIds) {
      await _liveSurveySubscriptions[id]?.cancel();
      _liveSurveySubscriptions.remove(id);
      await _responseUseCase.stopWatchingSurveyResults(surveyId: id);
    }

    if (!_isLiveUpdatesEnabled) {
      return;
    }

    for (final id in surveyIds) {
      if (_liveSurveySubscriptions.containsKey(id)) {
        continue;
      }

      _liveSurveySubscriptions[id] = _responseUseCase
          .watchSurveyResults(surveyId: id)
          .listen((_) {
            _liveRefreshDebounce?.cancel();
            _liveRefreshDebounce = Timer(const Duration(milliseconds: 350), () {
              add(const AdminSurveysRefreshed());
            });
          });
    }
  }

  Future<void> _clearLiveSurveySubscriptions() async {
    _liveRefreshDebounce?.cancel();
    _liveRefreshDebounce = null;

    final ids = _liveSurveySubscriptions.keys.toList();
    for (final id in ids) {
      await _liveSurveySubscriptions[id]?.cancel();
      _liveSurveySubscriptions.remove(id);
      await _responseUseCase.stopWatchingSurveyResults(surveyId: id);
    }
  }

  @override
  Future<void> close() async {
    await _clearLiveSurveySubscriptions();
    return super.close();
  }
}
