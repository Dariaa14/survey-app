/// Email contact entity.
abstract class EmailContactEntity {
  /// Email contact id (UUID).
  String get id;

  /// Associated email list id (UUID).
  String get listId;

  /// Email address.
  String get email;

  /// Contact name.
  String get name;

  /// Creation timestamp.
  DateTime get createdAt;
}
