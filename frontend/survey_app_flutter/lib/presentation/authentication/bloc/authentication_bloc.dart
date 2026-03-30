import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_event.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_state.dart';

/// Bloc for managing authentication state and events.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserUseCase _userUseCase;

  /// Constructs an [AuthenticationBloc] with the initial state
  /// of [AuthenticationState].
  AuthenticationBloc({required UserUseCase userUseCase})
    : _userUseCase = userUseCase,
      super(const AuthenticationState()) {
    on<AuthenticationStarted>(_onStarted);
    on<AuthenticationEmailChanged>(_onEmailChanged);
    on<AuthenticationPasswordChanged>(_onPasswordChanged);
    on<AuthenticationLoginSubmitted>(_onLoginSubmitted);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
    on<AuthenticationErrorCleared>(_onErrorCleared);
  }

  Future<void> _onStarted(
    AuthenticationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AuthenticationStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token != null && token.isNotEmpty) {
        emit(
          state
              .copyWith(
                status: AuthenticationStatus.authenticated,
                token: token,
              )
              .copyWithNull(nullErrorMessage: true),
        );
        return;
      }

      emit(
        state
            .copyWith(status: AuthenticationStatus.unauthenticated, token: '')
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          token: '',
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onEmailChanged(
    AuthenticationEmailChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    AuthenticationPasswordChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLoginSubmitted(
    AuthenticationLoginSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.email.trim().isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          errorMessage: 'Email and password are required.',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: AuthenticationStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final isLoggedIn = await _userUseCase.login(
        state.email.trim(),
        state.password,
      );

      if (!isLoggedIn) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            token: '',
            errorMessage: 'Invalid email or password.',
          ),
        );
        return;
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          token: '',
          errorMessage: 'Login step failed: $e',
        ),
      );
      return;
    }

    try {
      final token = await _userUseCase.getAuthToken() ?? '';
      final isAdmin = await _userUseCase.isCurrentUserAdmin();

      emit(
        state
            .copyWith(
              status: AuthenticationStatus.authenticated,
              isAdmin: isAdmin,
              token: token,
            )
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          token: '',
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(
      state
          .copyWith(status: AuthenticationStatus.loading)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      await _userUseCase.logout();
    } catch (_) {
      // Ignore logout errors and force local unauthenticated state.
    }

    emit(
      state
          .copyWith(
            status: AuthenticationStatus.unauthenticated,
            token: '',
            password: '',
            isAdmin: false,
          )
          .copyWithNull(nullErrorMessage: true),
    );
  }

  void _onErrorCleared(
    AuthenticationErrorCleared event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(state.copyWithNull(nullErrorMessage: true));
  }
}
