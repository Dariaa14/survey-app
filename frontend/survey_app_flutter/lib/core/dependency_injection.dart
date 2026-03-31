import 'package:get_it/get_it.dart';
import 'package:survey_app_flutter/data/repositories_impl/survey_repository_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/user_repository_impl.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_bloc.dart';

/// Instance of getIt
final GetIt getIt = GetIt.instance;

/// Method that loads all dependencies
void loadDependencies() {
  _loadRepositories();
  _loadUseCases();
  _loadBlocs();
}

/// Method that registers repositories
void _loadRepositories() {
  getIt.registerLazySingleton<SurveyRepository>(SurveyRepositoryImpl.new);
  getIt.registerLazySingleton<UserRepository>(UserRepositoryImpl.new);
}

/// Method that registers use cases
void _loadUseCases() {
  getIt.registerLazySingleton<SurveyUseCase>(
    () => SurveyUseCase(getIt.get<SurveyRepository>()),
  );
  getIt.registerLazySingleton<UserUseCase>(
    () => UserUseCase(getIt.get<UserRepository>()),
  );
}

void _loadBlocs() {
  getIt.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(userUseCase: getIt.get<UserUseCase>()),
  );
  getIt.registerLazySingleton<AdminBloc>(
    () => AdminBloc(
      surveyUseCase: getIt.get<SurveyUseCase>(),
      userUseCase: getIt.get<UserUseCase>(),
    ),
  );
  getIt.registerLazySingleton(
    () =>
        SurveyBuilderBloc(getIt.get<SurveyUseCase>(), getIt.get<UserUseCase>()),
  );
  getIt.registerLazySingleton(
    () => QuestionBuilderBloc(getIt.get<SurveyUseCase>()),
  );
}
