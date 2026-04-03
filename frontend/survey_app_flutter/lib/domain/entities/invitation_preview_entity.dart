/// Entity representing a preview of invitations to be sent.
abstract class InvitationPreviewEntity {
  /// Number of contacts that will receive a new invitation.
  int get newInvitations;

  /// Number of contacts that will be skipped because they were already invited.
  int get skipped;
}
