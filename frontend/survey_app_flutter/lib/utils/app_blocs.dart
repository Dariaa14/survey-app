import 'package:survey_app_flutter/core/dependency_injection.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';

/// Centralized access to blocs registered in dependency injection.
class AppBlocs {
  /// Private constructor to prevent instantiation.
  AppBlocs._();

  /// A static instance of [AuthenticationBloc] resolved from GetIt.
  static AuthenticationBloc authenticationBloc = getIt<AuthenticationBloc>();
}
