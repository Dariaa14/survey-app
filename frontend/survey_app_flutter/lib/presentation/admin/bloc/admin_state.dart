import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/domain/entities/user_entity.dart';

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
    this.errorMessage,
    this.adminUser,
  });

  /// The current admin user.
  final UserEntity? adminUser;

  /// Current loading status.
  final AdminStatus status;

  /// Surveys posted by the current admin.
  final List<SurveyEntity> surveys;

  /// Optional error message for failed operations.
  final String? errorMessage;

  /// Returns a copy with updated values.
  AdminState copyWith({
    UserEntity? adminUser,
    AdminStatus? status,
    List<SurveyEntity>? surveys,
    String? errorMessage,
  }) {
    return AdminState(
      adminUser: adminUser ?? this.adminUser,
      status: status ?? this.status,
      surveys: surveys ?? this.surveys,
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
      errorMessage: nullErrorMessage ? null : errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    adminUser,
    status,
    surveys,
    errorMessage,
  ];
}
