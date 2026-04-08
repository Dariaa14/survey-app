import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_event.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_state.dart';

/// Bloc for managing authentication state and events.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserUseCase _userUseCase;
  Timer? _tokenExpiryTimer;

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
          .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token != null && token.isNotEmpty) {
        final expiry = _extractTokenExpiry(token);
        if (_isExpired(expiry)) {
          await _userUseCase.logout();
          emit(
            state
                .copyWith(
                  status: AuthenticationStatus.unauthenticated,
                  token: '',
                  logoutMessage:
                      'Your session expired. Please authenticate again.',
                )
                .copyWithNull(nullErrorMessage: true),
          );
          return;
        }

        _scheduleTokenExpiryLogout(expiry);

        final isAdmin = await _userUseCase.isCurrentUserAdmin();

        emit(
          state
              .copyWith(
                status: AuthenticationStatus.authenticated,
                token: token,
                isAdmin: isAdmin,
              )
              .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
        );
        return;
      }

      emit(
        state
            .copyWith(status: AuthenticationStatus.unauthenticated, token: '')
            .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
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
          .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
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

      _scheduleTokenExpiryLogout(_extractTokenExpiry(token));

      emit(
        state
            .copyWith(
              status: AuthenticationStatus.authenticated,
              isAdmin: isAdmin,
              token: token,
            )
            .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
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
    _tokenExpiryTimer?.cancel();

    emit(
      state
          .copyWith(status: AuthenticationStatus.loading)
          .copyWithNull(nullErrorMessage: true, nullLogoutMessage: true),
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
            logoutMessage: event.reason ?? 'You have been logged out.',
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

  DateTime? _extractTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = jsonDecode(decodedPayload) as Map<String, dynamic>;
      final exp = payloadMap['exp'];

      final expSeconds = exp is int ? exp : int.tryParse(exp.toString());
      if (expSeconds == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(
        expSeconds * 1000,
        isUtc: true,
      );
    } catch (_) {
      return null;
    }
  }

  bool _isExpired(DateTime? expiry) {
    if (expiry == null) {
      return false;
    }

    return DateTime.now().toUtc().isAfter(expiry);
  }

  void _scheduleTokenExpiryLogout(DateTime? expiry) {
    _tokenExpiryTimer?.cancel();

    if (expiry == null) {
      return;
    }

    final remaining = expiry.difference(DateTime.now().toUtc());
    if (remaining <= Duration.zero) {
      add(
        const AuthenticationLogoutRequested(
          reason: 'Your session expired. Please authenticate again.',
        ),
      );
      return;
    }

    _tokenExpiryTimer = Timer(remaining, () {
      add(
        const AuthenticationLogoutRequested(
          reason: 'Your session expired. Please authenticate again.',
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _tokenExpiryTimer?.cancel();
    return super.close();
  }
}
