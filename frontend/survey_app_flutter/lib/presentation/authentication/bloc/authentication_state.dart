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

  /// Indicates whether the currently authenticated user has admin privileges.
  final bool isAdmin;

  /// Constructs an [AuthenticationState] with the given [status] and optional [errorMessage].
  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.token = '',
    this.isAdmin = false,
  });

  /// Creates a copy of the current state with updated fields.
  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? email,
    String? password,
    String? token,
    String? errorMessage,
    bool? isAdmin,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  /// Creates a copy of the current state with the error message set to null.
  AuthenticationState copyWithNull({bool nullErrorMessage = false}) =>
      AuthenticationState(
        status: status,
        email: email,
        password: password,
        token: token,
        errorMessage: nullErrorMessage ? null : errorMessage,
        isAdmin: isAdmin,
      );

  @override
  List<Object?> get props => [
    status,
    email,
    password,
    token,
    errorMessage,
    isAdmin,
  ];
}
