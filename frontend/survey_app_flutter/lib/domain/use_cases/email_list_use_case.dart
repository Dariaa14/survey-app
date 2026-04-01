import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_csv_import_result_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/repositories/email_list_repository.dart';

/// Business logic facade for email list operations.
class EmailListUseCase {
  final EmailListRepository _emailListRepository;

  /// Constructs an [EmailListUseCase] with the given [EmailListRepository].
  EmailListUseCase(EmailListRepository emailListRepository)
    : _emailListRepository = emailListRepository;

  /// Fetches all email lists for a specific owner.
  Future<List<EmailListEntity>> getEmailListsByUser({
    required String ownerId,
    required String token,
  }) async {
    return _emailListRepository.getEmailListsByUser(
      ownerId: ownerId,
      token: token,
    );
  }

  /// Fetches a single email list by id.
  Future<EmailListEntity> getEmailListById({
    required String listId,
    required String token,
  }) async {
    return _emailListRepository.getEmailListById(listId: listId, token: token);
  }

  /// Creates a new email list.
  Future<EmailListEntity> createEmailList({
    required String token,
    required String ownerId,
    required String name,
  }) async {
    return _emailListRepository.createEmailList(
      token: token,
      ownerId: ownerId,
      name: name,
    );
  }

  /// Updates the name of an existing email list.
  Future<EmailListEntity> updateEmailList({
    required String token,
    required String listId,
    required String name,
  }) async {
    return _emailListRepository.updateEmailList(
      token: token,
      listId: listId,
      name: name,
    );
  }

  /// Deletes an email list by id.
  Future<void> deleteEmailList({
    required String token,
    required String listId,
  }) async {
    return _emailListRepository.deleteEmailList(token: token, listId: listId);
  }

  /// Creates a contact in an email list.
  Future<EmailContactEntity> createContact({
    required String token,
    required String listId,
    required String email,
    String? name,
  }) async {
    return _emailListRepository.createContact(
      token: token,
      listId: listId,
      email: email,
      name: name,
    );
  }

  /// Updates an existing contact in an email list.
  Future<EmailContactEntity> updateContact({
    required String token,
    required String listId,
    required String contactId,
    required String email,
    String? name,
  }) async {
    return _emailListRepository.updateContact(
      token: token,
      listId: listId,
      contactId: contactId,
      email: email,
      name: name,
    );
  }

  /// Deletes a contact from an email list.
  Future<void> deleteContact({
    required String token,
    required String listId,
    required String contactId,
  }) async {
    return _emailListRepository.deleteContact(
      token: token,
      listId: listId,
      contactId: contactId,
    );
  }

  /// Imports contacts from a CSV file into an email list.
  Future<EmailListCsvImportResultEntity> importContactsCsv({
    required String token,
    required String listId,
    required String fileName,
    required List<int> csvBytes,
    required bool preview,
  }) async {
    return _emailListRepository.importContactsCsv(
      token: token,
      listId: listId,
      fileName: fileName,
      csvBytes: csvBytes,
      preview: preview,
    );
  }
}
