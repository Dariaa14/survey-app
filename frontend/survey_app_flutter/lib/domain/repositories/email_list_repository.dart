import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';

/// Repository interface for email list-related data operations.
abstract class EmailListRepository {
  /// Fetches all email lists for a specific owner.
  Future<List<EmailListEntity>> getEmailListsByUser({
    required String ownerId,
    required String token,
  });

  /// Fetches a single email list by its unique identifier.
  Future<EmailListEntity> getEmailListById({
    required String listId,
    required String token,
  });

  /// Creates a new email list in the data source.
  Future<EmailListEntity> createEmailList({
    required String token,
    required String ownerId,
    required String name,
  });

  /// Updates an existing email list in the data source.
  Future<EmailListEntity> updateEmailList({
    required String token,
    required String listId,
    required String name,
  });

  /// Deletes an email list from the data source by its unique identifier.
  Future<void> deleteEmailList({
    required String token,
    required String listId,
  });

  /// Creates a new contact in an email list.
  Future<EmailContactEntity> createContact({
    required String token,
    required String listId,
    required String email,
    String? name,
  });

  /// Updates an existing contact in an email list.
  Future<EmailContactEntity> updateContact({
    required String token,
    required String listId,
    required String contactId,
    required String email,
    String? name,
  });

  /// Deletes a contact from an email list.
  Future<void> deleteContact({
    required String token,
    required String listId,
    required String contactId,
  });

  /// Imports contacts from a CSV file into an email list.
  Future<void> importContactsCsv({
    required String token,
    required String listId,
    required String fileName,
    required List<int> csvBytes,
    required bool preview,
  });
}
