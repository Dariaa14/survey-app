import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';

/// Bloc for managing admin-related state and events.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final SurveyUseCase _surveyUseCase;
  final UserUseCase _userUseCase;

  /// Constructs an [AdminBloc] with the initial state of [AdminState].
  AdminBloc({
    required SurveyUseCase surveyUseCase,
    required UserUseCase userUseCase,
  }) : _surveyUseCase = surveyUseCase,
       _userUseCase = userUseCase,
       super(const AdminState()) {
    on<AdminAccountRequested>(_onAccountRequested);
    on<AdminSurveysRequested>(_onSurveysRequested);
    on<AdminSurveysRefreshed>(_onSurveysRefreshed);
    on<AdminErrorCleared>(_onErrorCleared);
    on<AdminSurveyFilterChanged>(_onSurveyFilterChanged);
    on<AdminSurveyPublishRequested>(_onSurveyPublishRequested);
    on<AdminSurveyCloseRequested>(_onSurveyCloseRequested);
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

      final surveys = await _surveyUseCase.getSurveysByUser(
        adminUser.id,
        token,
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

  void _onErrorCleared(AdminErrorCleared event, Emitter<AdminState> emit) {
    emit(state.copyWithNull(nullErrorMessage: true));
  }

  void _onSurveyFilterChanged(
    AdminSurveyFilterChanged event,
    Emitter<AdminState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
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
}
