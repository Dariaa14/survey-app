import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/entities/user_entity.dart';

/// Selected filter for surveys list.
enum AdminSurveyFilter {
  /// Show all surveys.
  all,

  /// Show only draft surveys.
  draft,

  /// Show only published surveys.
  published,

  /// Show only closed surveys.
  closed,
}

/// Loading status for admin surveys screen.
enum AdminStatus {
  /// Initial idle state.
  initial,

  /// Surveys are currently being fetched.
  loading,

  /// Surveys loaded successfully.
  success,

  /// Failed to load surveys.
  failure,
}

/// State for admin area containing the current user's posted surveys.
class AdminState extends Equatable {
  /// Creates an [AdminState].
  const AdminState({
    this.status = AdminStatus.initial,
    this.surveys = const <SurveyEntity>[],
    this.selectedFilter = AdminSurveyFilter.all,
    this.errorMessage,
    this.adminUser,
  });

  /// The current admin user.
  final UserEntity? adminUser;

  /// Current loading status.
  final AdminStatus status;

  /// Surveys posted by the current admin.
  final List<SurveyEntity> surveys;

  /// Selected surveys filter.
  final AdminSurveyFilter selectedFilter;

  /// Surveys after applying [selectedFilter].
  List<SurveyEntity> get filteredSurveys {
    switch (selectedFilter) {
      case AdminSurveyFilter.all:
        return surveys;
      case AdminSurveyFilter.draft:
        return surveys.where((survey) => survey.status == SurveyStatus.draft).toList();
      case AdminSurveyFilter.published:
        return surveys
            .where((survey) => survey.status == SurveyStatus.published)
            .toList();
      case AdminSurveyFilter.closed:
        return surveys.where((survey) => survey.status == SurveyStatus.closed).toList();
    }
  }

  /// Optional error message for failed operations.
  final String? errorMessage;

  /// Returns a copy with updated values.
  AdminState copyWith({
    UserEntity? adminUser,
    AdminStatus? status,
    List<SurveyEntity>? surveys,
    AdminSurveyFilter? selectedFilter,
    String? errorMessage,
  }) {
    return AdminState(
      adminUser: adminUser ?? this.adminUser,
      status: status ?? this.status,
      surveys: surveys ?? this.surveys,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Returns a copy with the current error removed.
  AdminState copyWithNull({
    bool nullAdminUser = false,
    bool nullErrorMessage = false,
  }) {
    return AdminState(
      adminUser: nullAdminUser ? null : adminUser,
      status: status,
      surveys: surveys,
      selectedFilter: selectedFilter,
      errorMessage: nullErrorMessage ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    adminUser,
    status,
    surveys,
    selectedFilter,
    errorMessage,
  ];
}
