import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/admin_main_page.dart';
import 'package:survey_app_flutter/presentation/authentication/authentication_page.dart';
import 'package:survey_app_flutter/presentation/authentication/registration_page.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_page.dart';
import 'package:survey_app_flutter/presentation/invitations/survey_invitations_page.dart';
import 'package:survey_app_flutter/presentation/public/survey_formular_page.dart';
import 'package:survey_app_flutter/presentation/results/results_page.dart';
import 'package:survey_app_flutter/presentation/survey_builder/survey_builder_page.dart';

/// Route path constants used across the app.
abstract final class AppRoutes {
  /// The authentication page path.
  static const String authentication = '/';

  /// The admin surveys list page path.
  static const String adminSurveys = '/admin/surveys';

  /// The registration page path.
  static const String registration = '/registration';

  /// The survey builder create page path.
  static const String adminSurveyCreate = '/admin/surveys/new';

  /// The survey builder edit page path pattern.
  static const String adminSurveyEdit = '/admin/surveys/:surveyId/edit';

  /// The email list details page path.
  static const String adminEmailList = '/admin/contacts/list';

  /// The survey invitations page path pattern.
  static const String adminSurveyInvitations =
      '/admin/surveys/:surveyId/invitations';

  /// The survey results page path pattern.
  static const String adminSurveyResults = '/admin/surveys/:surveyId/results';

  /// The public survey page path pattern.
  static const String publicSurvey = '/s/:slug';

  /// Builds a concrete public survey route from a slug and token.
  static String publicSurveyPath(String slug, String token) {
    return '/s/$slug?t=$token';
  }

  /// Builds a concrete survey invitations route from an id.
  static String adminSurveyInvitationsPath(String surveyId) {
    return '/admin/surveys/$surveyId/invitations';
  }

  /// Builds a concrete survey results route from an id.
  static String adminSurveyResultsPath(String surveyId) {
    return '/admin/surveys/$surveyId/results';
  }

  /// Builds a concrete survey edit route from an id.
  static String adminSurveyEditPath(String surveyId) {
    return '/admin/surveys/$surveyId/edit';
  }

  /// The survey builder create page route.
  static String adminSurveyCreatePath() {
    return adminSurveyCreate;
  }

  /// The email list details page route.
  static String adminEmailListPath() {
    return adminEmailList;
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
      path: AppRoutes.registration,
      builder: (context, state) => const RegistrationPage(),
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
    GoRoute(
      path: AppRoutes.adminEmailList,
      builder: (context, state) {
        final emailList = state.extra is EmailListEntity
            ? state.extra as EmailListEntity?
            : null;

        if (emailList == null) {
          return const AdminMainPage();
        }

        return EmailListPage(emailList: emailList);
      },
    ),
    GoRoute(
      path: AppRoutes.adminSurveyInvitations,
      builder: (context, state) {
        final survey = state.extra is SurveyEntity
            ? state.extra as SurveyEntity?
            : null;

        if (survey == null) {
          return const AdminMainPage();
        }

        return SurveyInvitationsPage(survey: survey);
      },
    ),
    GoRoute(
      path: AppRoutes.adminSurveyResults,
      builder: (context, state) {
        final survey = state.extra is SurveyEntity
            ? state.extra as SurveyEntity?
            : null;

        if (survey == null) {
          throw Exception('Survey data is required to view results');
        }

        return ResultsPage(
          survey: survey,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.publicSurvey,
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? '';
        final token = state.uri.queryParameters['t'] ?? '';

        return SurveyFormularPage(slug: slug, token: token);
      },
    ),
  ],
);
