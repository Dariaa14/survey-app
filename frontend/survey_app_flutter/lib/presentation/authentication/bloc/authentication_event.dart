/// This file defines the various events for the authentication
/// process in the application.
abstract class AuthenticationEvent {
  /// Creates an [AuthenticationEvent].
  const AuthenticationEvent();
}

/// Triggered when authentication flow starts (e.g., app launch)
/// to restore session.
class AuthenticationStarted extends AuthenticationEvent {
  /// Creates [AuthenticationStarted].
  const AuthenticationStarted();
}

/// Triggered when user updates the email input.
class AuthenticationEmailChanged extends AuthenticationEvent {
  /// Creates [AuthenticationEmailChanged].
  const AuthenticationEmailChanged(this.email);

  /// Updated email value.
  final String email;
}

/// Triggered when user updates the password input.
class AuthenticationPasswordChanged extends AuthenticationEvent {
  /// Creates [AuthenticationPasswordChanged].
  const AuthenticationPasswordChanged(this.password);

  /// Updated password value.
  final String password;
}

/// Triggered when user submits login credentials.
class AuthenticationLoginSubmitted extends AuthenticationEvent {
  /// Creates [AuthenticationLoginSubmitted].
  const AuthenticationLoginSubmitted();
}

/// Triggered when user logs out.
class AuthenticationLogoutRequested extends AuthenticationEvent {
  /// Creates [AuthenticationLogoutRequested].
  const AuthenticationLogoutRequested();
}

/// Triggered to clear the current error message from state.
class AuthenticationErrorCleared extends AuthenticationEvent {
  /// Creates [AuthenticationErrorCleared].
  const AuthenticationErrorCleared();
}
