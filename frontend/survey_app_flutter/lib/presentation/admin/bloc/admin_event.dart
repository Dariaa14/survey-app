import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';

/// Base class for all admin feature events.
abstract class AdminEvent {
  /// Creates an [AdminEvent].
  const AdminEvent();
}

/// Triggered when the admin account details should be loaded.
class AdminAccountRequested extends AdminEvent {
  /// Creates [AdminAccountRequested].
  const AdminAccountRequested();
}

/// Triggered when the admin surveys list should be loaded.
class AdminSurveysRequested extends AdminEvent {
  /// Creates [AdminSurveysRequested].
  const AdminSurveysRequested();
}

/// Triggered when the admin explicitly refreshes surveys.
class AdminSurveysRefreshed extends AdminEvent {
  /// Creates [AdminSurveysRefreshed].
  const AdminSurveysRefreshed();
}

/// Triggered when the admin email lists should be loaded.
class AdminEmailListsRequested extends AdminEvent {
  /// Creates [AdminEmailListsRequested].
  const AdminEmailListsRequested();
}

/// Triggered when the admin explicitly refreshes email lists.
class AdminEmailListsRefreshed extends AdminEvent {
  /// Creates [AdminEmailListsRefreshed].
  const AdminEmailListsRefreshed();
}

/// Triggered to create a new admin email list.
class AdminEmailListCreateRequested extends AdminEvent {
  /// New email list name.
  final String name;

  /// Creates [AdminEmailListCreateRequested].
  const AdminEmailListCreateRequested(this.name);
}

/// Triggered to update an existing admin email list.
class AdminEmailListUpdateRequested extends AdminEvent {
  /// Email list id.
  final String listId;

  /// New email list name.
  final String name;

  /// Creates [AdminEmailListUpdateRequested].
  const AdminEmailListUpdateRequested({
    required this.listId,
    required this.name,
  });
}

/// Triggered to delete an admin email list.
class AdminEmailListDeleteRequested extends AdminEvent {
  /// Email list id.
  final String listId;

  /// Creates [AdminEmailListDeleteRequested].
  const AdminEmailListDeleteRequested(this.listId);
}

/// Triggered to clear any error message from admin state.
class AdminErrorCleared extends AdminEvent {
  /// Creates [AdminErrorCleared].
  const AdminErrorCleared();
}

/// Triggered when surveys filter changes.
class AdminSurveyFilterChanged extends AdminEvent {
  /// Selected filter.
  final AdminSurveyFilter filter;

  /// Creates [AdminSurveyFilterChanged].
  const AdminSurveyFilterChanged(this.filter);
}

/// Triggered when admin changes selected main tab.
class AdminMainTabChanged extends AdminEvent {
  /// Selected tab.
  final AdminMainTab tab;

  /// Creates [AdminMainTabChanged].
  const AdminMainTabChanged(this.tab);
}

/// Triggered when an admin publishes a survey.
class AdminSurveyPublishRequested extends AdminEvent {
  /// Survey id to publish.
  final String surveyId;

  /// Creates [AdminSurveyPublishRequested].
  const AdminSurveyPublishRequested(this.surveyId);
}

/// Triggered when an admin closes a survey.
class AdminSurveyCloseRequested extends AdminEvent {
  /// Survey id to close.
  final String surveyId;

  /// Creates [AdminSurveyCloseRequested].
  const AdminSurveyCloseRequested(this.surveyId);
}
