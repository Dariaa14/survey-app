import 'package:get_it/get_it.dart';
import 'package:survey_app_flutter/data/repositories_impl/email_list_repository_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/response_repository_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/survey_repository_impl.dart';
import 'package:survey_app_flutter/data/repositories_impl/user_repository_impl.dart';
import 'package:survey_app_flutter/domain/repositories/email_list_repository.dart';
import 'package:survey_app_flutter/domain/repositories/response_repository.dart';
import 'package:survey_app_flutter/domain/repositories/survey_repository.dart';
import 'package:survey_app_flutter/domain/repositories/user_repository.dart';
import 'package:survey_app_flutter/domain/use_cases/email_list_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/response_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_bloc.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_bloc.dart';
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
  getIt.registerLazySingleton<EmailListRepository>(EmailListRepositoryImpl.new);
  getIt.registerLazySingleton<ResponseRepository>(ResponseRepositoryImpl.new);
}

/// Method that registers use cases
void _loadUseCases() {
  getIt.registerLazySingleton<SurveyUseCase>(
    () => SurveyUseCase(getIt.get<SurveyRepository>()),
  );
  getIt.registerLazySingleton<UserUseCase>(
    () => UserUseCase(getIt.get<UserRepository>()),
  );
  getIt.registerLazySingleton<EmailListUseCase>(
    () => EmailListUseCase(getIt.get<EmailListRepository>()),
  );
  getIt.registerLazySingleton<ResponseUseCase>(
    () => ResponseUseCase(getIt.get<ResponseRepository>()),
  );
}

void _loadBlocs() {
  getIt.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(userUseCase: getIt.get<UserUseCase>()),
  );
  getIt.registerLazySingleton<AdminBloc>(
    () => AdminBloc(
      emailListUseCase: getIt.get<EmailListUseCase>(),
      surveyUseCase: getIt.get<SurveyUseCase>(),
      userUseCase: getIt.get<UserUseCase>(),
    ),
  );
  getIt.registerLazySingleton<EmailListBuilderBloc>(
    () => EmailListBuilderBloc(
      emailListUseCase: getIt.get<EmailListUseCase>(),
      userUseCase: getIt.get<UserUseCase>(),
    ),
  );
  getIt.registerLazySingleton<SurveyBuilderBloc>(
    () =>
        SurveyBuilderBloc(getIt.get<SurveyUseCase>(), getIt.get<UserUseCase>()),
  );
  getIt.registerLazySingleton<QuestionBuilderBloc>(
    () => QuestionBuilderBloc(getIt.get<SurveyUseCase>()),
  );
  getIt.registerLazySingleton<InvitationsBloc>(
    () => InvitationsBloc(
      getIt.get<SurveyUseCase>(),
      getIt.get<UserUseCase>(),
    ),
  );
  getIt.registerLazySingleton<PublicBloc>(
    () => PublicBloc(
      getIt.get<SurveyUseCase>(),
      getIt.get<ResponseUseCase>(),
    ),
  );
}
