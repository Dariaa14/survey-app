/// Entity representing an invitation to a survey.
abstract class InvitationEntity {
  /// Invitation id (UUID).
  String get id;

  /// Target survey id.
  String get surveyId;

  /// Target email list id.
  String get contactId;

  /// Invitation token hash from backend.
  String get tokenHash;

  /// Timestamp of when the invitation was sent.
  DateTime get sentAt;

  /// Timestamp of when the invitation was opened by the recipient,
  /// null if not opened yet.
  DateTime? get emailOpenedAt;

  /// Timestamp of when the survey was opened by the recipient,
  /// null if not opened yet.
  DateTime? get surveyOpenedAt;

  /// Timestamp of when the survey was submitted by the recipient,
  /// null if not submitted yet.
  DateTime? get submittedAt;

  /// Timestamp of when the invitation bounced back,
  /// null if not bounced.
  DateTime? get bouncedAt;
}
