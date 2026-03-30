import 'package:get_it/get_it.dart';
import 'package:survey_app_flutter/data/repositories_impl/survey_repository_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/user_repository_impl.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';

/// Instance of getIt
final GetIt getIt = GetIt.instance;

/// Method that loads all dependencies
void loadDependencies() {
  _loadRepositories();
  _loadUseCases();
}

/// Method that registers repositories
void _loadRepositories() {
  getIt.registerLazySingleton<SurveyRepository>(SurveyRepositoryImpl.new);
  getIt.registerLazySingleton<UserRepository>(UserRepositoryImpl.new);
}

/// Method that registers use cases
void _loadUseCases() {
  //getIt.registerLazySingleton<SurveyUseCase>(SurveyUseCase.new);
  getIt.registerLazySingleton<UserUseCase>(
    () => UserUseCase(getIt.get<UserRepository>()),
  );
}
