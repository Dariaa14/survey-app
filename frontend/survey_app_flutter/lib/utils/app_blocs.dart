import 'package:survey_app_flutter/core/dependency_injection.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_bloc.dart';

/// Centralized access to blocs registered in dependency injection.
class AppBlocs {
  /// Private constructor to prevent instantiation.
  AppBlocs._();

  /// A static instance of [AuthenticationBloc] resolved from GetIt.
  static AuthenticationBloc authenticationBloc = getIt<AuthenticationBloc>();

  /// A static instance of [AdminBloc] resolved from GetIt.
  static AdminBloc adminBloc = getIt<AdminBloc>();

  /// A static instance of [SurveyBuilderBloc] resolved from GetIt.
  static SurveyBuilderBloc surveyBuilderBloc = getIt<SurveyBuilderBloc>();
}
