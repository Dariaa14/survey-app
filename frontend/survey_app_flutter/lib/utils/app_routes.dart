import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/presentation/admin/surveys_list_page.dart/surveys_list_page.dart';
import 'package:survey_app_flutter/presentation/authentication/authentication_page.dart';

/// Route path constants used across the app.
abstract final class AppRoutes {
  /// The authentication page path.
  static const String authentication = '/';

  /// The admin surveys list page path.
  static const String adminSurveys = '/admin/surveys';
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
      builder: (context, state) => const SurveysListPage(),
    ),
  ],
);
