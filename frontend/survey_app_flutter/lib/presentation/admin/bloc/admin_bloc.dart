import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';

/// Bloc for managing admin-related state and events.
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final SurveyRepository _surveyRepository;
  final UserRepository _userRepository;

  /// Constructs an [AdminBloc] with the initial state of [AdminState].
  AdminBloc({
    required SurveyRepository surveyRepository,
    required UserRepository userRepository,
  }) : _surveyRepository = surveyRepository,
       _userRepository = userRepository,
       super(const AdminState()) {
    on<AdminAccountRequested>(_onAccountRequested);
    on<AdminSurveysRequested>(_onSurveysRequested);
    on<AdminSurveysRefreshed>(_onSurveysRefreshed);
    on<AdminErrorCleared>(_onErrorCleared);
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
      final adminUser = await _userRepository.getCurrentUser();

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
      final surveys = await _surveyRepository.getSurveysByUser(
        adminUser.id,
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
      final surveys = await _surveyRepository.getSurveysByUser(adminUser.id);

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
}
