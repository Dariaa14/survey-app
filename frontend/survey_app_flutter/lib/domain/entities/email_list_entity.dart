import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';

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

  /// The list of email contacts associated with this email list.
  List<EmailContactEntity> get contacts;
}
