import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/entities/invitation_entity.dart';
import 'package:survey_app_flutter/domain/entities/invitation_preview_entity.dart';

/// State class for the invitations logic.
class InvitationsState extends Equatable {
  /// Invitations loaded for the current survey.
  final List<InvitationEntity> invitations;

  /// Total invitations count for the survey (unfiltered).
  final int totalInvitationsCount;

  /// Preview for the currently selected list.
  final InvitationPreviewEntity? invitationPreview;

  /// Whether invitations are currently being sent.
  final bool isSendingInvitations;

  /// The email list selected for sending invitations, if any.
  final EmailListEntity? selectedEmailList;

  /// Creates an [InvitationsState] with optional survey and selected email list.
  const InvitationsState({
    this.invitations = const <InvitationEntity>[],
    this.totalInvitationsCount = 0,
    this.invitationPreview,
    this.isSendingInvitations = false,
    this.selectedEmailList,
  });

  /// Creates a copy of the current state with optional new values.
  InvitationsState copyWith({
    List<InvitationEntity>? invitations,
    int? totalInvitationsCount,
    InvitationPreviewEntity? invitationPreview,
    bool? isSendingInvitations,
    EmailListEntity? selectedEmailList,
  }) {
    return InvitationsState(
      invitations: invitations ?? this.invitations,
      totalInvitationsCount:
          totalInvitationsCount ?? this.totalInvitationsCount,
      invitationPreview: invitationPreview ?? this.invitationPreview,
      isSendingInvitations: isSendingInvitations ?? this.isSendingInvitations,
      selectedEmailList: selectedEmailList ?? this.selectedEmailList,
    );
  }

  /// Creates a copy of the current state with optional nullification of fields.
  InvitationsState copyWithNull({
    bool nullSurvey = false,
    bool nullInvitationPreview = false,
    bool nullIsSendingInvitations = false,
    bool nullSelectedEmailList = false,
  }) {
    return InvitationsState(
      invitations: invitations,
      totalInvitationsCount: totalInvitationsCount,
      invitationPreview: nullInvitationPreview ? null : invitationPreview,
      isSendingInvitations: nullIsSendingInvitations
          ? false
          : isSendingInvitations,
      selectedEmailList: nullSelectedEmailList ? null : selectedEmailList,
    );
  }

  @override
  List<Object?> get props => [
    invitations,
    totalInvitationsCount,
    invitationPreview,
    isSendingInvitations,
    selectedEmailList,
  ];
}
