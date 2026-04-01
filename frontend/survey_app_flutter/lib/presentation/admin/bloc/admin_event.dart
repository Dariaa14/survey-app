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
