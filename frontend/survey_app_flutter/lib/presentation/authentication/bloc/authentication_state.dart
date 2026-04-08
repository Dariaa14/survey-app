import 'package:equatable/equatable.dart';

/// Authentication status.
enum AuthenticationStatus {
  /// Initial state before any authentication attempt
  initial,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,

  /// Authentication process is in progress
  loading,
}

/// State for the authentication process in the application.
class AuthenticationState extends Equatable {
  /// The current authentication status.
  final AuthenticationStatus status;

  /// The email of the user attempting to authenticate.
  final String email;

  /// The password of the user attempting to authenticate.
  final String password;

  /// The authentication token received upon successful authentication.
  final String token;

  /// An optional error message if authentication fails.
  final String? errorMessage;

  /// Optional message explaining why the user was logged out.
  final String? logoutMessage;

  /// Indicates whether the currently authenticated user has admin privileges.
  final bool isAdmin;

  /// Indicates if registration just completed successfully.
  final bool registrationCompleted;

  /// Constructs an [AuthenticationState] with the given [status] and optional [errorMessage].
  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.errorMessage,
    this.logoutMessage,
    this.email = '',
    this.password = '',
    this.token = '',
    this.isAdmin = false,
    this.registrationCompleted = false,
  });

  /// Creates a copy of the current state with updated fields.
  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? email,
    String? password,
    String? token,
    String? errorMessage,
    String? logoutMessage,
    bool? isAdmin,
    bool? registrationCompleted,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      logoutMessage: logoutMessage ?? this.logoutMessage,
      isAdmin: isAdmin ?? this.isAdmin,
      registrationCompleted:
          registrationCompleted ?? this.registrationCompleted,
    );
  }

  /// Creates a copy of the current state with nullable message fields set to null.
  AuthenticationState copyWithNull({
    bool nullErrorMessage = false,
    bool nullLogoutMessage = false,
  }) => AuthenticationState(
    status: status,
    email: email,
    password: password,
    token: token,
    errorMessage: nullErrorMessage ? null : errorMessage,
    logoutMessage: nullLogoutMessage ? null : logoutMessage,
    isAdmin: isAdmin,
    registrationCompleted: registrationCompleted,
  );

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    token,
    errorMessage,
    logoutMessage,
    isAdmin,
    registrationCompleted,
  ];
}
