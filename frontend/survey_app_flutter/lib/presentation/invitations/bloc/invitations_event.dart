import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';

/// Event class for the invitations logic.
abstract class InvitationsEvent {}

/// Event for selecting an email list to send invitations to.
class InvitationsContactListSelected extends InvitationsEvent {
  /// The email list that was selected.
  final EmailListEntity? emailList;

  /// Creates a [InvitationsContactListSelected] with the given email list.
  InvitationsContactListSelected(this.emailList);
}

/// Event for loading invitations for a survey.
class LoadSurveyInvitations extends InvitationsEvent {
  /// Survey whose invitations should be loaded.
  final SurveyEntity survey;

  /// Creates a [LoadSurveyInvitations] event.
  LoadSurveyInvitations(this.survey);
}

/// Event for loading a preview of invitations for the selected list.
class LoadInvitationPreview extends InvitationsEvent {
  /// Survey used to fetch the preview.
  final SurveyEntity survey;

  /// Creates a [LoadInvitationPreview] event.
  LoadInvitationPreview(this.survey);
}
