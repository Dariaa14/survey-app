import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
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

/// Selected tab for admin main page.
enum AdminMainTab {
  /// Surveys management tab.
  surveys,

  /// Contacts lists management tab.
  contacts,
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
  /// Maximum number of surveys for client-side real-time filtering.
  static const int clientSideFilterThreshold = 200;

  /// Creates an [AdminState].
  const AdminState({
    this.status = AdminStatus.initial,
    this.surveys = const <SurveyEntity>[],
    this.emailLists = const <EmailListEntity>[],
    this.selectedTab = AdminMainTab.surveys,
    this.selectedFilter = AdminSurveyFilter.all,
    this.usesServerFiltering = false,
    this.errorMessage,
    this.adminUser,
  });

  /// The current admin user.
  final UserEntity? adminUser;

  /// Current loading status.
  final AdminStatus status;

  /// Surveys posted by the current admin.
  final List<SurveyEntity> surveys;

  /// Email lists owned by the current admin.
  final List<EmailListEntity> emailLists;

  /// Selected tab in admin main page.
  final AdminMainTab selectedTab;

  /// Selected surveys filter.
  final AdminSurveyFilter selectedFilter;

  /// Whether filter changes should be resolved server-side.
  final bool usesServerFiltering;

  /// Surveys after applying [selectedFilter].
  List<SurveyEntity> get filteredSurveys {
    if (usesServerFiltering) {
      return surveys;
    }

    switch (selectedFilter) {
      case AdminSurveyFilter.all:
        return surveys;
      case AdminSurveyFilter.draft:
        return surveys
            .where((survey) => survey.status == SurveyStatus.draft)
            .toList();
      case AdminSurveyFilter.published:
        return surveys
            .where((survey) => survey.status == SurveyStatus.published)
            .toList();
      case AdminSurveyFilter.closed:
        return surveys
            .where((survey) => survey.status == SurveyStatus.closed)
            .toList();
    }
  }

  /// Optional error message for failed operations.
  final String? errorMessage;

  /// Returns a copy with updated values.
  AdminState copyWith({
    UserEntity? adminUser,
    AdminStatus? status,
    List<SurveyEntity>? surveys,
    List<EmailListEntity>? emailLists,
    AdminMainTab? selectedTab,
    AdminSurveyFilter? selectedFilter,
    bool? usesServerFiltering,
    String? errorMessage,
  }) {
    return AdminState(
      adminUser: adminUser ?? this.adminUser,
      status: status ?? this.status,
      surveys: surveys ?? this.surveys,
      emailLists: emailLists ?? this.emailLists,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      usesServerFiltering: usesServerFiltering ?? this.usesServerFiltering,
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
      emailLists: emailLists,
      selectedTab: selectedTab,
      selectedFilter: selectedFilter,
      usesServerFiltering: usesServerFiltering,
      errorMessage: nullErrorMessage ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    adminUser,
    status,
    surveys,
    emailLists,
    selectedTab,
    selectedFilter,
    usesServerFiltering,
    errorMessage,
  ];
}
