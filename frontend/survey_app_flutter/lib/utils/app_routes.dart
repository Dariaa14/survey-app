import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/admin_main_page.dart';
import 'package:survey_app_flutter/presentation/authentication/authentication_page.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_page.dart';
import 'package:survey_app_flutter/presentation/invitations/survey_invitations_page.dart';
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

  /// The email list details page path.
  static const String adminEmailList = '/admin/contacts/list';

  /// The survey invitations page path pattern.
  static const String adminSurveyInvitations =
      '/admin/surveys/:surveyId/invitations';

  /// Builds a concrete survey invitations route from an id.
  static String adminSurveyInvitationsPath(String surveyId) {
    return '/admin/surveys/$surveyId/invitations';
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
  ],
);
