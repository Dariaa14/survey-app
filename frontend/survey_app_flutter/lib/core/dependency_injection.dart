import 'package:get_it/get_it.dart';
import 'package:survey_app_flutter/data/repositories_impl/survey_repository_impl.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';

/// Instance of getIt
final GetIt getIt = GetIt.instance;

/// Method that registers repositories
void loadRepositories() {
  getIt.registerLazySingleton<SurveyRepository>(SurveyRepositoryImpl.new);
}
