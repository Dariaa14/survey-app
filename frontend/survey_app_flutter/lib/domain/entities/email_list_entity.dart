/// Entity representing a list of email addresses for survey distribution.
abstract class EmailListEntity {
  /// Unique identifier for the email list (UUID).
  String get id;

  /// Owner user id (UUID) associated with this email list.
  String get ownerId;

  /// List name or label.
  String get name;

  /// Time when the email list was created.
  DateTime get createdAt;
}
