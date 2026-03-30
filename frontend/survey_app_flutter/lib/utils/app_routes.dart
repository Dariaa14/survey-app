import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/admin_main_page.dart';
import 'package:survey_app_flutter/presentation/authentication/authentication_page.dart';
import 'package:survey_app_flutter/presentation/survey_builder/survey_builder_page.dart';

/// Route path constants used across the app.
abstract final class AppRoutes {
  /// The authentication page path.
  static const String authentication = '/';

  /// The admin surveys list page path.
  static const String adminSurveys = '/admin/surveys';

  /// The survey builder create page path.
  static const String adminSurveyCreate = '/admin/surveys/new';

  /// The survey builder edit page path pattern.
  static const String adminSurveyEdit = '/admin/surveys/:surveyId/edit';

  /// Builds a concrete survey edit route from an id.
  static String adminSurveyEditPath(String surveyId) {
    return '/admin/surveys/$surveyId/edit';
  }

  /// The survey builder create page route.
  static String adminSurveyCreatePath() {
    return adminSurveyCreate;
  }
}

/// The app-level router configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.authentication,
  routes: [
    GoRoute(
      path: AppRoutes.authentication,
      builder: (context, state) => const AuthenticationPage(),
    ),
    GoRoute(
      path: AppRoutes.adminSurveys,
      builder: (context, state) => const AdminMainPage(),
    ),
    GoRoute(
      path: AppRoutes.adminSurveyCreate,
      builder: (context, state) => const SurveyBuilderPage(),
    ),
    GoRoute(
      path: AppRoutes.adminSurveyEdit,
      builder: (context, state) {
        final survey = state.extra is SurveyEntity
            ? state.extra as SurveyEntity?
            : null;

        return SurveyBuilderPage(survey: survey);
      },
    ),
  ],
);
